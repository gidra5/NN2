class Bullet extends Drawable
{
    final float speed = 3;
    PVector direction;

    Bullet()
    {
        super();
        init();
        r = 50;
    }

    void init()
    {
        int i=round(random(1,4));
        switch(i)
        {
            case 1:
                pos.x=random(0,width);
                pos.y=-r;
                break;
            case 2:
                pos.x=-r;
                pos.y=random(0,height);
                break;
            case 3:
                pos.x=width+r;
                pos.y=random(0,height);
                break;
            case 4:
                pos.x=random(0,width);
                pos.y=height+r;
                break;
        }
        direction=PVector.random2D();
    }

    void move()
    {
        pos.x+=direction.x*speed;
        pos.y+=direction.y*speed;
    
        pos.x=min(width+r,max(-r,pos.x));
        pos.y=min(height+r,max(-r,pos.y));
    
        if(!isOnScreen()) 
            init();
    }

    void update()
    {
        move();
        display();
    }
}