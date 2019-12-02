class NeuralNetwork implements Cloneable
{
    private NeuronLayer[] layers;

    NeuralNetwork(int ...neuronsPerLayer)
    {
        layers = new NeuronLayer[neuronsPerLayer.length];

        layers[0] = new NeuronLayer(neuronsPerLayer[0], null);
    
        for(int i = 1; i < neuronsPerLayer.length; ++i)
            layers[i] = new NeuronLayer(neuronsPerLayer[i], layers[i-1]);
    }

    void setInput(float[] in)
    {
        layers[0].setValues(in);
    }

    float[] getOutput()
    {
        return layers[layers.length - 1].getValues();
    }

    void randomChange()
    {
        for(NeuronLayer nl : layers)
        {
            for(float b : nl.biases)
                b += randomGaussian();
            
            for(int i = 0; i < nl.weights.length; ++i)
                for(int j = 0; j < nl.weights[i].length; ++j)
                    nl.weights[i][j] += randomGaussian();
        }
    }

    Object clone() throws CloneNotSupportedException
    {
        return super.clone();
    }

    final float x = 150, y = 75, spaceX = 40, spaceY = 25, r = 20;

    void display()
    {
        float[] l_values;
        float[][] l_weights;
        color tmpColor;
        colorMode(HSB);

        for (int i = 0; i < layers.length; ++i)
        {
            l_values = layers[i].getValues();
            l_weights = layers[i].weights;

            for (int j = 0; j < l_values.length; ++j)
            {
                for (int k = 0; k < l_weights[j].length; ++k)
                {
                    tmpColor = color(120 * sigmoid(l_weights[j][k]), 255, 255);
                    fill(tmpColor);
                    line(x + i * spaceX, y + j * spaceY, x + (i - 1) * spaceX, y + k * spaceY);
                }

                tmpColor = color(120 * sigmoid(l_values[j]), 255, 255);
                fill(tmpColor);
                ellipse(x + i * spaceX, y + j * spaceY, r, r);
            }
        }

        colorMode(RGB);
    }

    float sigmoid(float x)
    {
        x = 1/(1+exp(-x));
        return x;
    }

    private class NeuronLayer implements Cloneable
    {
        NeuronLayer pl;
        private float[] values;
        float[] biases;
        float[][] weights;

        int neuronsN = 0;

        NeuronLayer(int neuronsN, NeuronLayer pl) //pl - previous layer
        {
            int pl_neuronsN;

            if(pl == null) pl_neuronsN = 0; 
            else {
                pl_neuronsN = pl.neuronsN;
                this.pl = pl;
            }

            this.neuronsN = neuronsN;

            values = new float[neuronsN];
            biases = new float[neuronsN];

            for(int i = 0; i < neuronsN; ++i)
            {
                values[i] = 0;
                biases[i] = randomGaussian();
            }

            weights = new float[neuronsN][pl_neuronsN];

            for(int i = 0; i < neuronsN; ++i)
                for(int j = 0; j < pl_neuronsN; ++j)
                    weights[i][j] = randomGaussian();
        }

        void setValues(float[] v)
        {
            values = v;
        }

        float[] getValues()
        {
            if(pl == null)
                return values;

            float[] pl_values = pl.getValues();

            for(int i = 0; i < neuronsN; ++i)
            {
                for(int j = 0; j < pl.neuronsN; ++j)
                    values[i] += weights[i][j] * pl_values[j];
                values[i] += biases[i];
            }

            return sigmoid(values);
        }

        float[] sigmoid(float[] x)
        {
            for(int i = 0;   i < x.length; ++i)
                x[i] = 2/(1+exp(-x[i])) - 1;
            return x;
        }

        Object clone() throws CloneNotSupportedException
        {
            return super.clone();
        }
    }
}