
ArrayList<Bullet> bullets;
ArrayList<Player> players;
ArrayList<Player> dead_players;
final int playersN = 5;
final int bulletsN = 10;
int generation = 0;

void setup()
{
    size(800, 600);
    //fullScreen();
    frameRate(300);
    ellipseMode(CENTER);
    textSize(20);

    bullets = new ArrayList<Bullet>();
    players = new ArrayList<Player>();
    dead_players = new ArrayList<Player>();

    for(int i = 0; i < bulletsN; ++i)
        bullets.add(new Bullet());
    
    for(int i = 0; i < playersN; ++i)
        players.add(new Player());
}

void draw()
{
    background(127);

    for(Bullet b : bullets)
        b.update();

    for(Player p : players)
        p.update();

    players.removeAll(dead_players);

    if(players.isEmpty())
        setup();

    text(frameRate, 50, 50);
}