
-- Torch program that creates a simple AutoEncoder-style neural network, where output=input
print('\n\n @ @ @ @ @ @ START @ @ @ @ @ @ @ ');
print('Torch program that creates a simple AutoEncoder-style neural network, where output=input');
print('author Davide Chicco <davide.chicco@gmail.com>');
print(os.date("%c", os.time()));
istante = os.date("%c", os.time());
print('versione con noise al 10% nell\'input e curve ROC al variare della threshold');

require 'os'

-- function that rounds a real value to the closest integer
function roundToInt(num)
    under = math.floor(num)
    upper = math.floor(num) + 1
    underV = -(under - num)
    upperV = upper - num
    if (upperV > underV) then
        return under
    else
        return upper
    end
end

-- function that sees if the file exists (from the web)
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end


-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
lines_from = function (file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

-- rounds a real number num to the number having idp values after the dot
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

 -- open the files

-- file = 'data/__stampa_matrice_GallusGallus9031-CC.txt';
file = 'data/__stampa_matrice_BosTaurus9913-CC.txt';
-- file = 'data/__stampa_matrice_BosTaurus9913-CC_prime10righe.txt';
-- file = 'data/prova.txt'
lines = lines_from(file); -- we take the lines

    experiment = {}
    genes = {}
    features = {}
    annotations = {}
    annotationsNoised = {}

-- print all line numbers and their contents
for k,v in pairs(lines) do

    -- leggiamo il titolo dell'esperimento
    if string.match(v,'experiment:') then
      experiment = v;
      print(experiment);
    end
    -- leggiamo gli OID dei geni e li mettiamo nell'array genes
    if string.match(v,'genes:') then
      gNum =-1 --numero dei geni
	  for token in string.gmatch(v, "[^%s]+") do
	    -- saltiamo la prima parola: e' "genes"
	    if gNum ~= -1 and token~=';'  then genes[gNum] =  token; end
	    gNum=gNum+1;
	  end
    end
     -- leggiamo gli OID delle caratteristiche e li mettiamo nell'array features
    if string.match(v,'features:') then
    fNum = -1 --numero delle caratteristiche
     for token in string.gmatch(v, "[^%s]+") do
       	    -- saltiamo la prima parola: e' "features"
	    if fNum ~= -1 and token~=';'  then features[fNum] =  token; end
	    fNum=fNum+1;
	  end
    end
end

print('#genes', #genes);
print('#features', #features);
require 'os';
--os.exit()

-- lines = lines_from(file);
flagAnn = false -- dice se siamo arrivati alle annotazioni
-- idea generale: lista di righe (profili genici) di zeri ed uni
gpNum = -1 --numero dei profili genici
for k,v in pairs(lines) do
    -- lettura zeri ed uni delle annotazioni
    if string.match(v,'annotations:') then flagAnn = true; gpNum = -1; end
    
    if flagAnn == true and gpNum~=-1 then
    gA =1;
    -- gene_profile = {}; -- gene_profile e' una riga
     gene_profile = torch.Tensor(#features);

      for token in string.gmatch(v, "[^%s]+") do
	if token~=';' and token~=';;'   then
	 -- print('token ' ..token);
	  gene_profile[gA] =  tonumber(token);
	  gA=gA+1;
	 --print('gene_profile['.. gA ..']', gene_profile[gA]);
	end
      end
    annotations[gpNum] = gene_profile;
    annotationsNoised[gpNum] = gene_profile;
    
    end
   
    gpNum = gpNum + 1;
end


-- Aggiungiamo il rumore
for i=0,(#genes-1) do
  for j=1,(#features) do
    if annotationsNoised[i][j]==1 then
      a = math.random();
      if a >= 0.8 then annotationsNoised[i][j] = 0;
      end
    end
  end
end


sampleNumber = #genes;
dataset = {} -- declaration of the input dataset
function dataset:size() return sampleNumber end -- input dataset hgas 

 -- Set the parameters and the experiment title
inputs=#features; -- the inputs layer has dimension 207
outputs=inputs; -- the inputs has dimension 207 -- if it's not an Auto-Encoder, outputs =1 or another number
-- HUs=roundToInt(#features/2); -- Hidden units
HUs = 1;
io.write("Insert the number of hidden units HUs \n");
io.flush()
HUs=io.read()
HUs = tonumber(HUs);

print('# of hidden units HUs='..HUs);
concats = 2 -- number of concatenations in the dataset creation
 threshold = 'varyin\' from 0 to 1';
  print('likelihood threshold=' .. threshold ..'%');
   experiment = experiment .. " threshold=".. threshold .. " HUs=" .. HUs .. '\n';
  experiment = string.gsub(experiment,' ','_');
  experiment = string.gsub(experiment,'	','_');
  	

print('\n-- data building --');
-- data building
for i=1,dataset:size() do	-- 15 times

    dataset[i] = {annotationsNoised[i-1], annotations[i-1]} 
    --ricordarsi sempre che il numero di geni va da 0 a #genes-1, mentre quello di caratteristiche va da 1 a #features 
end

 -- print('dataset:dim() ',dataset:dim());
 print('dataset:size() ',dataset:size());
--  print('dataset[1]:size() ',dataset[1]:size());
-- print('dataset[1]:nDimension() ',dataset[1]:nDimension());
 -- print('dataset[1] ',dataset[1]);

 
-- here we print the content of the matrix dataset
for i=1,sampleNumber do
  for j=1,concats do
     --  print('dataset[' .. i .. '][' .. j .. ']', dataset[i][j]);
  end  
  
end    

-- Creation of the neural network
print('-- creation of the neural network --');
require "nn"
mlp=nn.Sequential();  -- make a multi-layer perceptron
mlp:add(nn.Linear(inputs,HUs)) -- adds a (input x HUs)  layer to the network
mlp:add(nn.Sigmoid());
mlp:add(nn.Linear(HUs,outputs)) -- adds a (HUs x outputs)  layer to the network
mlp:add(nn.Sigmoid()); -- Sigmoid also in output, Peter says

-- Training
print('-- training --');
criterion = nn.MSECriterion() 
trainer = nn.StochasticGradient(mlp, criterion)
trainer.learningRate = 0.01
trainer:train(dataset)

-- Testing
print('-- testing --');
geneProfileChosen = 0;
x=torch.Tensor(inputs);   -- create a test example Tensor. Test element: first gene

istante = string.gsub(istante,',','_');
istante = string.gsub(istante,':','-');
istante = string.gsub(istante,' ','_');

-- per stampare la APlist, mettere questo flag a true
printOutputMatrix = false;
if printOutputMatrix then file = "data/stampa_matrice_output.txt"; end
printAPlist = false;
if printAPlist then fileAPs = "data/stampa_ap_list".. istante ..".xml" end

local f,err;
if printOutputMatrix then f,err = io.open(file,"w"); end
local f2,err;
if printAPlist then f2,err = io.open(fileAPs,"w"); end


-- Print of the results
if printAPlist then
  f2:write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
  f2:write("<predicted_annotations>\n");
  f2:write("<experiment_name>\n");
  f2:write(experiment);
  f2:write("</experiment_name>\n");
end



if printOutputMatrix then
  f:write(experiment); 
  gene_oid_feature_oid = '(gene oid, feature oid)\n';
  f:write(gene_oid_feature_oid);
end

-- apriamo file per la scrittura delle Roc
fileRoc = 'data/_roc_curves.txt';
printRoc = true;
local fRoc,err;
if printRoc then fRoc,err = io.open(fileRoc,"w"); fRoc.close(); end
if printRoc then fRoc,err = io.open(fileRoc,"a"); end

-- array delle soglie
thresholdArray = {}
start = 0.01;
incremento = 0.01;
maxThresholdArray = 100;
 for i=0, maxThresholdArray-1 do
  thresholdArray[i] = start;
  start = start+incremento;
end

  
if printAPlist then f2:write("<annotation_list>\n"); end

for q=0, #thresholdArray-1 do
    threshold = thresholdArray[q];
    globalAP = 0;
    globalAC = 0;
    globalNAC = 0;
    globalAR = 0;
    
    --  ciclo su tutti i profili genici
    for geneProfileChosen=0, #genes-1 do
      
	    for u=1, inputs do
	      x[u] = annotations[geneProfileChosen][u]; -- Attenzione agli indici!!! Qui stiamo testando il profilo genico 0
	    end   

	    
	    
	    -- applicazione del metodo Auto-Encoder effettiva all'insieme di testing
	    pred=mlp:forward(x)  -- applies the module mlp to x
	    -- print('pred:\n', pred)          -- print it

	    array = {};
	    for i=1,inputs do
	      -- print('pred['.. i ..']:\t', pred[i])          -- print it 
	      array[i] = round(pred[i], 3);
	    end

	    require 'math'
	    mini = math.min(unpack(array));
	    maxi = math.max(unpack(array));
	    average = mini + (maxi-mini)/2;
	    -- print('the min is '.. mini);
	    -- print('the max is '.. maxi);
	    -- print('the average is '.. average);

	    -- threshold = average
	    localAP = 0;
	    
	    -- if not f then return print(err) end
	    if printOutputMatrix then
	      print('attention: we\'re goin\' to write the file\n' .. file);
	      f:write('\t ### GeneProfile ' .. geneProfileChosen .. ' ### \n'); 
	    end
	    
		    
	    for i=1,inputs do
	      -- riga = '<'..genes[geneProfileChosen] .. ', ' .. features[i-1] .. '> (' ..x[i] .. ', ' ..array[i] .. ')';
	      riga = '('..genes[geneProfileChosen] .. ', ' .. features[i-1] .. '),';
	      if printOutputMatrix then f:write(riga .. '\n'); end
	      
	      -- diviamo tra AP, AC, AR, NAC
	      if x[i]==0 and array[i]> threshold then
		    if printAPlist then
		      f2:write("<annotation>\n");
		      f2:write("<entity_oid>" .. genes[geneProfileChosen] .. "</entity_oid>\n");
		      f2:write("<term_oid>" .. features[i-1] .. "</term_oid>\n");
		      f2:write("<prediction_value>" .. array[i] .. "</prediction_value>\n");
		      f2:write("</annotation>\n");
		      f2:write('\n');
		    end
		    localAP=localAP+1;
		    globalAP=globalAP+1;
	      elseif x[i]==0 and array[i]<= threshold then globalNAC = globalNAC+1 
	      elseif x[i]==1 and array[i]> threshold then globalAC = globalAC+1 
	      elseif x[i]==1 and array[i]<= threshold then globalAR = globalAR+1 
	      end
	    localApPercentage = round(localAP*100/inputs, 2);
	    -- print('local annotations predicted (AP): ' .. localAP .. ' over ' .. inputs .. ', equal to ' .. localApPercentage ..'%\n');
	    end
    end


if printOutputMatrix then f:close(); end;

if printAPlist then
  f2:write("</annotation_list>\n");
  f2:write("</predicted_annotations>\n");
  f2:close();
end  
  
  globalApPercentage = round(globalAP*100/(#genes*#features), 2);
  print('global annotations predicted (AP): ' .. globalAP .. ' over ' .. #genes*#features .. ', equal to ' .. globalApPercentage ..'%\n');
  print('threshold ' .. threshold);
  print('globalAP = ' .. globalAP ..'\t globalAC = ' .. globalAC ..'\t globalNAC = ' .. globalNAC ..'\t globalAR = ' .. globalAR .. '\n');
  
  ACrate = globalAC / (globalAC + globalAR);
  APrate = globalAP / (globalAP + globalNAC);
  ACrate = round(ACrate, 3);
  APrate = round(APrate, 3);
  print('ACrate = ' .. ACrate);
  print('APrate = ' .. APrate);  
  if printRoc then
    -- fRoc:write(ACrate .. '\t' .. APrate ..'\t' ..  threshold .. '\n');
    fRoc:write(ACrate .. '\t' .. APrate ..'\n');
  end  
   q = q+1;
end 
  


 



if printRoc then  fRoc:close(); end  
  print('\n-:-:-:-:-:-:-:-:-:-:-\n')
  print('experiment parameters:')
print(experiment);
print('-:-:-:-:-:-:-:-:-:-:-\n')

print('Da sistemare:\n');
print('la matrice rumorosa e\' troppo rumorosa?\n');
print('Le AUC sono bassissime, sistemare\n');
  
print('@ @ @ @ @ END @ @ @ @ @ ');

