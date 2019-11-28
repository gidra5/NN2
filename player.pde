class Player extends Drawable implements Comparable<Player>
{
    private float[]       info            = new float[8];
    private float         directionAngle  = 0; // angle between x-axis and direction of movement in radians
    private final float   maxSpeed        = 5;
    private float         speed           = 1;
    NeuralNetwork         nn              = new NeuralNetwork(info.length, 4, 2);
    
    int birth;
    int score;

    Player()
    {
        super();
        spawn();
        directionAngle = random(0, TWO_PI);
    }

    int compareTo(Player p) 
    {
        return p.score - score;   
    }

    void spawn()
    {
        birth = frameCount;
        pos.x = width / 2;
        pos.y = height / 2;
    }

    void move()
    {
        pos.x += cos(directionAngle) * speed;
        pos.y += sin(directionAngle) * speed;
    
        pos.x = min(width  + r,max(-r,pos.x));
        pos.y = min(height + r,max(-r,pos.y));
    
        if(!isOnScreen())
            dead();
    }

    void observe()
    {
        int n = info.length;

        for(Bullet b : bullets)
        {
            PVector d = PVector.sub(b.pos, pos).normalize();
            
            for(int i = 0; i < n; ++i)
            {
                float proj = cos(TWO_PI * i/n) * d.x + sin(TWO_PI * i/n) * d.y;
                if(proj > 0 && abs(cos(TWO_PI * i/n) * d.y - sin(TWO_PI * i/n) * d.x) < b.r/2)
                    info[i] = min(info[i], proj);
            }
        }   
    }

    void think()
    {
        nn.setInput(info);
        float[] out = nn.getOutput();

        speed            = maxSpeed * out[0];
        directionAngle  -= PI       * out[1];

        directionAngle = directionAngle % TWO_PI;
    }

    void dead()
    {        
        score = frameCount-birth;
        deadPlayers.add(this);
    }

    boolean isDead()
    {
        boolean res = false;
        for(Bullet b : bullets)
        {
            res |= PVector.dist(b.pos, pos) < (b.r + r)/2;
            if(res)
            {
                dead();
                break;
            }
        }
        
        return res;
    }

    void update()
    {
        if(!isDead());
        {
            observe();
            think();
            move();
            display();
        }
    }
}