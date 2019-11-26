class Player extends Drawable implements Comparable<Player>
{
    float speed = 1;
    PVector direction = new PVector(0,0);
    NeuralNetwork nn = new NeuralNetwork(4, 2);

    int birth;
    int score;

    Player()
    {
        super();
        spawn();
        direction = PVector.random2D();
    }

    int compareTo(Player p) //используется в Arrays.sort()
    {
        return p.score - score; //если счёт
        //у опонента больше - ты ниже в массиве  
    }

    void spawn()
    {
        birth = frameCount;
        pos.x = width / 2;
        pos.y = height / 2;
    }

    void move()
    {
        pos.x += direction.x*speed;
        pos.y += direction.y*speed;
    
        pos.x = min(width+r,max(-r,pos.x));
        pos.y = min(height+r,max(-r,pos.y));
    
        if(!isOnScreen())
            dead();
    }

    void dead()
    {        
        score = frameCount-birth;
        dead_players.add(this);
    }

    void update()
    {
        move();
        display();
    }
}