require 'nn'
require 'unsup'

inputSize = 5;
outputSize = 5;

trainInputMat = {}

-- data building
trainInputMat = torch.Tensor(inputSize);
outputMat = torch.Tensor(outputSize);
trainInputMat=torch.Tensor(inputSize,inputSize)
for i=1,inputSize do
 for j=1,inputSize do
   a=math.random();
   if(a>=0.5) then trainInputMat[i][j] = 0.0;
   else trainInputMat[i][j]=1.0;
   end
 end
end
-- 
print(trainInputMat);
outputMat = trainInputMat;
print(outputMat);

-- training
 mlp=nn.Sequential();  -- make a multi-layer perceptron
inputs=2; outputs=1; HUs=20;
mlp:add(nn.Linear(inputs,HUs)) -- aggiunge uno strato con tensore di dimensione 5x5
 mlp:add(nn.Tanh())
 mlp:add(nn.Linear(HUs,outputs))-- aggiunge uno strato con tensore di dimensione 5x5
 
 criterion = nn.MSECriterion() 
trainer = nn.StochasticGradient(mlp, criterion)
trainer.learningRate = 0.01
trainer:train(trainInputMat)
--[[
-- testing

testInputMat = torch.Tensor(inputSize);
outputMat = torch.Tensor(outputSize);
testInputMat=torch.Tensor(inputSize,inputSize)
for i=1,5 do
 for j=1,5 do
   a=math.random();
   if(a>=0.5) then testInputMat[i][j] = 0;
   else testInputMat[i][j]=1;
   end
 end
end


pred=mlp:forward(testInputMat)  -- get the prediction of the mlp
print(pred)          -- print it ]]