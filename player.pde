class Player extends Drawable implements Comparable<Player>
{
    private float[]       info            = new float[10];
    private PVector       direction       = new PVector();
    private final float   maxSpeed        = 2;
    NeuralNetwork         nn              = new NeuralNetwork(info.length, 2);
    
    int birth;
    int score;

    Player()
    {
        super();
        spawn();
        direction = PVector.random2D();
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
        pos.x += direction.x * maxSpeed;
        pos.y += direction.y * maxSpeed;
    
        pos.x = min(width  + r,max(-r,pos.x));
        pos.y = min(height + r,max(-r,pos.y));
    
        if(!isOnScreen())
            dead();
    }

    void observe()
    {
        int n = info.length;
        float angleDivision = TWO_PI / n;
        float maxDist = sq(height)+sq(width)-sq(bullets.get(0).r+r)/4;
        float directionAngle = 0;
    
        for(int i = 0; i < n; ++i)
        {
            float angle = angleDivision * i + directionAngle;
            float ax = cos(angle), ay = sin(angle);

            float intersectPointX = min(max(pos.x + ax * (scrCenter.y / abs(ay) - pos.y / ay) / scrCenter.x, -1), 1);
            float intersectPointY = min(max(pos.y + ay * (scrCenter.x / abs(ax) - pos.x / ax) / scrCenter.y, -1), 1);

            float proj = ax * intersectPointX + ay * intersectPointY;
            if(proj > 0)
                info[i] = proj;

            for(Bullet b : bullets)
            {
                PVector d = PVector.sub(b.pos, pos);
                d.x /= scrCenter.x;
                d.y /= scrCenter.y;
                
                proj = ax * d.x + ay * d.y;
                if(proj > 0)
                    info[i] = min(info[i], proj);
            }
        }
    }

    void think()
    {
        nn.setInput(info);
        float[] out = nn.getOutput();

        //speed            = maxSpeed * out[0];
        //directionAngle   = PI       * out[1];

        //directionAngle = directionAngle % TWO_PI;
        direction.x = out[0];
        direction.y = out[1];

        direction.mult(maxSpeed / 1.4142);
    }

    void dead()
    {        
        score = frameCount-birth;
        deadPlayers.add(this);
    }

    boolean isDead()
    {
        boolean hitAnyBullet = false;
        for(Bullet b : bullets)
        {
            hitAnyBullet |= PVector.dist(b.pos, pos) < (b.r + r)/2;
            if(hitAnyBullet)
            {
                dead();
                break;
            }
        }
        
        return hitAnyBullet;
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