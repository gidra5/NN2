import java.util.*;

ArrayList<Bullet> bullets;
ArrayList<Player> players;
ArrayList<Player> deadPlayers;
PlayerInfograph info = new PlayerInfograph();
final int playersN = 50;
final int bulletsN = 100;
final int selection = 5;
int epoch = 1;

void setup()
{
    //size(800, 600);
    fullScreen();
    frameRate(300);
    ellipseMode(CENTER);
    textSize(20);

    bullets = new ArrayList<Bullet>();
    players = new ArrayList<Player>();
    deadPlayers = new ArrayList<Player>();

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

    players.removeAll(deadPlayers);

    if(players.isEmpty())
        newEpoch();

    text(frameRate, 50, 50);
    text(epoch, 150, 50);

    info.p = players.get(0);

    info.display();
}

void newEpoch()
{
    bullets.removeAll(bullets);
    for(int i = 0; i < bulletsN; ++i)
        bullets.add(new Bullet());

    List<Player> top = deadPlayers.subList(playersN - 1 - selection, playersN - 1);

    for(int i = 0; i < playersN; ++i) 
    {
        Player p = new Player();
        try { 
            p.nn = (NeuralNetwork) top.get(i % (selection - 1)).nn.clone();
        } catch (Exception e) { e.printStackTrace(); }
        p.nn.randomChange();

        players.add(p);
    }

    deadPlayers.removeAll(deadPlayers);

    epoch++;
}