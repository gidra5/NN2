abstract class Drawable {
    PVector pos;
    float r;
    color c;

    final PVector scrCenter = new PVector(width / 2, height / 2);

    Drawable()
    {
        pos = new PVector(-1,-1);
        r = 10;
        c = color(255,120,0);
    }

    void display()
    {
        fill(c);
        ellipse(pos.x, pos.y, r, r);
        fill(0);
    }

    boolean isOnScreen(PVector p)
    {
        return abs(p.x - scrCenter.x) < ( width / 2 + r) &&
               abs(p.y - scrCenter.y) < (height / 2 + r);
    }
    
    boolean isOnScreen()
    {
        return isOnScreen(pos);
    }

    abstract void update();
}