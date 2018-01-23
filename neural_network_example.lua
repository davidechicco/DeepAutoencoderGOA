dataset={};
function dataset:size() return 5 end -- 100 examples
for i=1,dataset:size() do
    local input= torch.randn(2);     --normally distributed example in 2d
    local output= torch.Tensor(1);
    if input[1]*input[2]>0 then    --calculate label for XOR function
        output[1]=-1;
    else
        output[1]=1;
    end
    dataset[i] = {input, output};
end

-- for i=1,dataset:size()  do
--   for j=1,2 do
--        print('dataset[' .. i .. '][' .. j .. ']', dataset[i][j]);
--    end  
-- end  

for i=1,dataset:size()  do
       print('dataset[' .. i .. ']', dataset[i]);
end  

print('dataset:size() ' .. dataset:size());
-- datasets qui e' una matrice 5x2, cinque righe e due colonne
    
require "nn"
mlp=nn.Sequential();  -- make a multi-layer perceptron
inputs=2; outputs=1; HUs=20;
mlp:add(nn.Linear(inputs,HUs))
mlp:add(nn.Tanh())
mlp:add(nn.Linear(HUs,outputs))

criterion = nn.MSECriterion() 
trainer = nn.StochasticGradient(mlp, criterion)
trainer.learningRate = 0.01
trainer:train(dataset)

x=torch.Tensor(2);   -- create a test example Tensor
x[1]=0.5; x[2]=-0.5; -- set its values
pred=mlp:forward(x)  -- get the prediction of the mlp
print('pred', pred)          -- print it 