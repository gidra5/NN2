class NeuralNetwork
{
    NeuronLayer[] layers;

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

    class NeuronLayer 
    {
        private float[] values;
        private float[] biases;
        private float[][] weights;
        private NeuronLayer pl;

        int neuronsN = 0;

        NeuronLayer(int neuronsN, NeuronLayer pl) //pl - previous layer
        {
            int pl_neuronsN;

            if(pl == null) pl_neuronsN = 0; 
            else pl_neuronsN = pl.neuronsN;

            this.neuronsN = neuronsN;

            values = new float[neuronsN];
            biases = new float[neuronsN];

            for(int i = 0; i < neuronsN; ++i)
            {
                values[i] = 0;
                biases[i] = 0;
            }

            weights = new float[neuronsN][pl_neuronsN];

            for(int i = 0; i < neuronsN; ++i)
                for(int j = 0; j < pl_neuronsN; ++j)
                    weights[i][j] = 0;
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

            return fn(values);
        }

        float[] fn(float[] x)
        {
            for(int i = 0; i < x.length; ++i)
                x[i] = 1/(1+exp(x[i]));
            return x;
        }
    }
}