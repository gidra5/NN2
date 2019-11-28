class Player extends Drawable implements Comparable<Player>
{
    private float[]       info            = new float[4];
    private NeuralNetwork nn              = new NeuralNetwork(info.length, 2);
    private float         direction_angle = 0; // angle between x-axis and direction of movement in radians
    private final float   maxSpeed       = 5;
    private float         speed           = 1;
    
    int birth;
    int score;

    Player()
    {
        super();
        spawn();
        direction_angle = random(0, TWO_PI);
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
        pos.x += cos(direction_angle) * speed;
        pos.y += sin(direction_angle) * speed;
    
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
            PVector d = PVector.sub(b.pos, pos);
            
            for(int i = 0; i < n; ++i)
                info[i] = min(info[i], cos(TWO_PI * i/n) * d.x + sin(TWO_PI * i/n) * d.y);
        }   
    }

    void think()
    {
        nn.setInput(info);
        float[] out = nn.getOutput();

        speed            = maxSpeed * out[0];
        direction_angle -= TWO_PI    * out[1];

        direction_angle = direction_angle % TWO_PI;
    }

    void dead()
    {        
        score = frameCount-birth;
        dead_players.add(this);
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