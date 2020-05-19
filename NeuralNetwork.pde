class NeuralNetwork implements Cloneable
{
    NeuronLayer[] layers;

    NeuralNetwork(int ...neuronsPerLayer)
    {
        layers = new NeuronLayer[neuronsPerLayer.length];

        if (layers.length >= 1) { 
            layers[0] = new NeuronLayer(neuronsPerLayer[0], null);
        
            for(int i = 1; i < neuronsPerLayer.length; ++i)
                layers[i] = new NeuronLayer(neuronsPerLayer[i], layers[i-1]);
        }
    }

    void setInput(float[] in)
    {
        layers[0].setValues(in);
    }

    float[] getOutput()
    {
        return layers[layers.length - 1].getValues();
    }

    void randomChange(float rate)
    {
        for(NeuronLayer nl : layers)
        {
            for(float b : nl.biases)
                b += rate*randomGaussian();
            
            for(int i = 0; i < nl.weights.length; ++i)
                for(int j = 0; j < nl.weights[i].length; ++j)
                    nl.weights[i][j] += rate*randomGaussian();
        }
    }

    Object clone() throws CloneNotSupportedException
    {
        NeuralNetwork cloned = new NeuralNetwork();
        cloned.layers = new NeuronLayer[this.layers.length];

        for (int i = 0; i < this.layers.length; ++i) {
            cloned.layers[i] = (NeuronLayer) this.layers[i].clone();
            if (i != 0) cloned.layers[i].pl = cloned.layers[i - 1];
        }

        return cloned;
    }

    final float x = 150, y = 75, spaceX = 50, spaceY = 25, r = 20;

    void display()
    {
        float[] l_values;
        float[][] l_weights;
        color tmpColor;
        float sigmVal=0;

        for (int i = 0; i < layers.length; ++i)
        {
            l_values = layers[i].getValues();
            l_weights = layers[i].weights;

            for (int j = 0; j < l_values.length; ++j)
            {
                for (int k = 0; k < l_weights[j].length; ++k)
                {
                    sigmVal = sigmoid(l_weights[j][k]);
                    tmpColor = color(255 * sigmVal, 0, 255 * (1 - sigmVal));
                    fill(tmpColor);
                    line(x + i * spaceX, y + j * spaceY, x + (i - 1) * spaceX, y + k * spaceY);
                }
                
                sigmVal = sigmoid(l_values[j]);
                tmpColor = color(255 * sigmVal, 0, 255 * (1 - sigmVal));
                fill(tmpColor);
                ellipse(x + i * spaceX, y + j * spaceY, r, r);
            }
        }
    }

    float sigmoid(float x)
    {
        return 1/(1+exp(-x));
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

            if(pl == null) 
                pl_neuronsN = 0; 
            else {
                pl_neuronsN = pl.neuronsN;
                this.pl = pl;
            }

            this.neuronsN = neuronsN;

            values = new float[neuronsN];
            biases = new float[neuronsN];
            weights = new float[neuronsN][pl_neuronsN];

            for(int i = 0; i < neuronsN; ++i)
            {
                values[i] = 0;
                biases[i] = randomGaussian();

                for(int j = 0; j < pl_neuronsN; ++j)
                    weights[i][j] = randomGaussian();
            }
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
                values[i] = 0;
                
                for(int j = 0; j < pl.neuronsN; ++j)
                    values[i] += weights[i][j] * pl_values[j];
                values[i] += biases[i];
            }

            return func(values);
        }

        Object clone() throws CloneNotSupportedException
        {
            NeuronLayer cloned = new NeuronLayer(neuronsN, null);

            cloned.biases = new float[neuronsN];
            cloned.weights = new float[neuronsN][weights[0].length];

            for(int i = 0; i < neuronsN; ++i)
            {
                cloned.biases[i] = biases[i];
                
                for(int j = 0; j < weights[i].length; ++j)
                    cloned.weights[i][j] = weights[i][j];
            }

            return cloned;
        }

        float[] func(float[] x)
        {
            for(int i = 0;  i < x.length; ++i)
                x[i] = func(x[i]);
            return x;
        }

        float func(float x)
        {
            return 2*sigmoid(x) - 1;
        }

        float sigmoid(float x)
        {
            return 1/(1+exp(-x));
        }

        float relu(float x)
        {
            return (x-abs(-x))/2;
        }

    }
}