class PlayerInfograph
{
    Player p;

    PlayerInfograph() { }

    void display()
    {
        text(p.direction.x, 50, 100);
        text(p.direction.y, 50, 150);

        p.nn.display();
    }
}