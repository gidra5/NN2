class NeuralNetwork
{
    NeuronLayer[] layers;

    NeuralNetwork(int ...neuronsPerLayer)
    {
        layers = new NeuronLayer[neuronsPerLayer.length];

        layers[0] = new NeuronLayer(neuronsPerLayer[0], 0);
    
        for(int i = 1; i < neuronsPerLayer.length; ++i)
            layers[i] = new NeuronLayer(neuronsPerLayer[i], neuronsPerLayer[i-1]);
    }

    float[] calculate()
    {
        float[] data = new float[layers[layers.length-1].neurons.length];
        for(int i = 0; i < layers[layers.length-1].neurons.length; ++i)
            data[i] = layers[layers.length-1].neurons[i].getValue();

        return data;
    }

    class NeuronLayer 
    {
        Neuron[] neurons;

        NeuronLayer(int neuronsN, int pl_neuronsN)
        {
            neurons = new Neuron[neuronsN];

            for(int i = 0; i < neuronsN; ++i)
                neurons[i] = new Neuron(pl_neuronsN);
        }
    }

    class Neuron 
    {
        float value = 0;
        float bias = 0;
        float[] weights;

        Neuron(int pl_neuronsN)
        {
            weights = new float[pl_neuronsN];

            for(float w : weights)
                w = 0;
        }

        float getValue()
        {


            return value;
        }
    }
}