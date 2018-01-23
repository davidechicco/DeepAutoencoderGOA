
-- Torch program that creates a simple AutoEncoder-style neural network, where output=input
print('\n\n @ @ @ @ @ @ START @ @ @ @ @ @ @ ');
print('Torch program that creates a simple AutoEncoder-style neural network, where output=input');
print('author Davide Chicco <davide.chicco@gmail.com>');

timeStart = os.time();
print(os.date("%c", os.time()));
istante = os.date("%c", os.time());
print('versione di test SENZA noise al 10% nell\'input e produzione test su file XML');

require 'os'
require 'gnuplot'
require './funzioni/AucComputer'
require './funzioni/round_functions'
require './funzioni/file_functions'
-- %%% main() %%%

-- file = 'data/__stampa_matrice_GallusGallus9031-MF.txt';
 file = 'data/__stampa_matrice_BosTaurus9913-MF.txt';
-- file = 'data/__stampa_matrice_HomoSapiens9606-BP.txt';
-- file = 'data/__stampa_matrice_BosTaurus9913-CC_prime10righe.txt';
-- file = 'data/prova.txt'
 
print('-- Select the dataset');
 
 require'lfs'
fileArray = {};
z = 0;
print('\n Choose the dataset to analyze:');
for dataFile in lfs.dir[[./data/]] do
  if dataFile:lower():find('__stampa_matrice')  then
    print(z..') '.. dataFile .. ' dataset found file found'); 
    fileArray[z] = dataFile;
    z = z+1;
  end  
end

local answer
repeat
   io.write('insert a number between 0 and '..(z-1)..' ');
   io.flush()
   answer=io.read()
until tonumber(answer) >= 0 and tonumber(answer) < z
print('You chose ('..tonumber(answer)..'): ' .. fileArray[tonumber(answer)]);
file = './data/'..fileArray[tonumber(answer)];
print('selected file: ' .. file);
 
 -- Start the reading of the file
 
lines = lines_from(file); -- we take the lines

firstFileNamePart, secondFileNamePart = file:match("([^,]+)_([^,]+)")
datasetName = secondFileNamePart:gsub(".txt", "");
print('datasetName ' .. datasetName);



    experiment = {}
    genes = {}
    features = {}
    annotations = {}
    annotationsNoised = {}

    print('-- data reading');
    
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

-- noisePercentage = 0.1

-- NON METTIAMO IL RUMORE

-- Aggiungiamo il rumore
-- print('-- noise adding');
-- for i=0,(#genes-1) do
--   for j=1,(#features) do
--     if annotationsNoised[i][j]==1 then
--       a = math.random();
--       if a >= (1-noisePercentage) then annotationsNoised[i][j] = 0;
--       end
--     end
--   end
-- end


sampleNumber = #genes;
dataset = {} -- declaration of the input dataset
function dataset:size() return sampleNumber end -- input dataset hgas 

 -- Set the parameters and the experiment title
inputs=#features; -- the inputs layer has dimension 207
outputs=inputs; -- the inputs has dimension 207 -- if it's not an Auto-Encoder, outputs =1 or another number

HUs = 1;
io.write("Insert the number of hidden units HUs \n");
io.flush()
HUs=io.read()
HUs = tonumber(HUs);
print('You chose '..HUs..' hidden units ');


threshold = 0;
io.write("Insert the value of threshold \n");
io.flush()
threshold=io.read()
threshold = tonumber(threshold);
print('You chose '..threshold..' as threshold ');


topK = 0;
io.write("Insert the number of topK annotations \n");
io.flush()
topK=io.read()
topK = tonumber(topK);
print('You chose '..topK..' topK annotations ');

hl = 1;
repeat
   io.write('Insert the number of hidden layers (hl_max)');
   io.flush()
   hl=io.read()
   hl = tonumber(hl)
until hl >= 0 and hl < 9

print('You chose '..hl..' hidden layer(s)');



HUsArray = {}
areaArray = {}

for i=1, hl do
  HUsArray[i] = i;
  areaArray[i] = -1;
end

concats = 2 -- number of concatenations in the dataset creation
  	

print('\n-- dataset building --');
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


 
-- apriamo file per la scrittura delle Auc al variare del numero di HUs
fileAucs = 'data/_aucs_autoencoder_'..datasetName..'_1hl_'..istante..'.txt';
printAucs = false;
if printAucs then fAucs,err = io.open(fileAucs,"w"); end

    -- -- << Ciclo per ogni valore possibile di HUs >> --
    -- print('-- Cycle for every possible number of hidden units [START]');
    -- step = 10
    -- for h=1, sampleNumber, step do -- ONE SHOT
    -- -- for h=1, 1, step do -- ONE SHOT
    -- 
    -- 	 HUs = HUsArray[h]; --ONE SHOT
    -- 	 print('h: '..h);
    -- 	if h >= sampleNumber then break; end
    -- 	print('if '..h..' >= '..sampleNumber..' then break; end');

	    print('number of hidden units, fixed HUs');

	    print('HUs '..HUs);

	    print('threshold fixed\n');
	    
	      print('likelihood threshold=' .. threshold ..'%');
	      print('topK annotations= ' ..topK);
	      experiment = experiment .. " threshold=".. threshold .. " HUs=" .. HUs ..  " topK=" .. topK ..  " hl=" .. hl .. '\n';
	      experiment = string.gsub(experiment,' ','_');
	      experiment = string.gsub(experiment,'	','_');
	      --print(experiment);

	    -- Creation of the neural network
	    print('-- creation of the neural network --');
	    require "nn"
	    mlp=nn.Sequential();  -- make a multi-layer perceptron
	    mlp:add(nn.Linear(inputs,HUs)) -- adds a (input x HUs)  layer to the network
	    mlp:add(nn.Sigmoid());
	    
	     -- aggiungiamo w strati DEEP LEARNING
	    for w=1, hl do
	      mlp:add(nn.Linear(HUs,HUs)) -- DEEP LEARNING layer
	      mlp:add(nn.Sigmoid()); -- DEEP LEARNING 
	    end
	    
	    mlp:add(nn.Linear(HUs,outputs)) -- adds a (HUs x outputs)  layer to the network -- DEEP LEARNING 
	    mlp:add(nn.Sigmoid()); -- Sigmoid also in output, Peter says

	    -- Training
	    print('-- training --');
	    criterion = nn.MSECriterion() 
	    trainer = nn.StochasticGradient(mlp, criterion)
	    trainer.learningRate = 0.01
	    trainer:train(dataset)

	    -- Testing
	    geneProfileChosen = 0;
	    x=torch.Tensor(inputs);   -- create a test example Tensor. Test element: first gene

	    istante = string.gsub(istante,',','_');
	    istante = string.gsub(istante,':','-');
	    istante = string.gsub(istante,' ','_');

	    -- per stampare la APlist, mettere questo flag a true
	    printOutputMatrix = false;
	    if printOutputMatrix then file = "data/stampa_matrice_output.txt"; end
	    printAPlist = true;
	    if printAPlist then fileAPs = "data/stampa_ap_list".. datasetName .."_".. istante ..".xml" end

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
	      f2:write(datasetName);
	      f2:write("</experiment_name>\n");
	    end



	    if printOutputMatrix then
	      f:write(experiment); 
	      gene_oid_feature_oid = '(gene oid, feature oid)\n';
	      f:write(gene_oid_feature_oid);
	    end

	    -- apriamo file per la scrittura delle Roc
	    fileRoc = 'data/_roc_curves.txt';
	    printRoc = false;


	    ACrateArray = torch.Tensor(inputs);
	    APrateArray = torch.Tensor(inputs);
	    APlistValueArray = {};
	    APlistGeneOidArray = {};
	    APlistFeatureOidArray = {};
	    apCount = 1;

	    i=0;  
	    if printAPlist then f2:write("<annotation_list>\n"); end

    -- 	-- << Ciclo per ogni valore possibile di threshold >> --
    -- 	print('\t-- Cycle for every possible value of threshold [START] - HUs='..HUs);
    -- 	for q=1, inputs do
		globalAP = 0;
		globalAC = 0;
		globalNAC = 0;
		globalAR = 0;
		
		-- <<< Ciclo per ogni possibile profilo genico >>> --
		    print('\t\t-- Cycle for every gene profile [START] - HUs='..HUs.. ', threshold='.. threshold);
		for geneProfileChosen=0, #genes-1 do
		  
			for u=1, inputs do
			  x[u] = annotations[geneProfileChosen][u]; -- Attenzione agli indici!!! Qui stiamo testando il profilo genico 0
			end   

			-- applicazione del metodo Auto-Encoder effettiva all'insieme di testing
    -- 		    -- print('\t\t\t-- testing --');
			pred=mlp:forward(x)  -- applies the module mlp to x
			-- print('pred:\n', pred)          -- print it

			array = {};
			for i=1,inputs do
			  -- print('pred['.. i ..']:\t', pred[i])          -- print it 
			  array[i] = pred[i];
			end

			--threshold = array[q];
		    --     print('threshold: array['..q..'] ' .. threshold);
			localAP = 0;
			
			-- if not f then return print(err) end
			if printOutputMatrix then
			  print('attention: we\'re goin\' to write the file\n' .. file);
			  f:write('\t ### GeneProfile ' .. geneProfileChosen .. ' ### \n'); 
			end
			
			-- <<< Ciclo per ogni caratteristica >>> -- 
			-- print('\t\t\t-- Cycle for every feature [START]');
			for i=1,inputs do
			  -- riga = '<'..genes[geneProfileChosen] .. ', ' .. features[i-1] .. '> (' ..x[i] .. ', ' ..array[i] .. ')';
			  riga = '('..genes[geneProfileChosen] .. ', ' .. features[i-1] .. '),';
			  if printOutputMatrix then f:write(riga .. '\n'); end
			  
			  -- print('\t\t\t\t -- Computin\' AP, AC, AR, NAC');
			  -- diviamo tra AP, AC, AR, NAC
			  if x[i]==0 and array[i]> threshold then
				
				  
				  APlistValueArray[apCount] = array[i];
				  APlistGeneOidArray[apCount] = genes[geneProfileChosen];
				  APlistFeatureOidArray[apCount] = features[i-1]
				
				  localAP=localAP+1;
				globalAP=globalAP+1;
				apCount = apCount+1;
					      
			  elseif x[i]==0 and array[i]<= threshold then globalNAC = globalNAC+1 
			  elseif x[i]==1 and array[i]> threshold then globalAC = globalAC+1 
			  elseif x[i]==1 and array[i]<= threshold then globalAR = globalAR+1 
			  end
			
			-- print('local annotations predicted (AP): ' .. localAP .. ' over ' .. inputs .. ', equal to ' .. localApPercentage ..'%\n');
			end
			-- print('\t\t\t-- Cycle for every feature [END]');
			-- <<</ Ciclo per ogni caratteristica >>> --
		end
		print('\t\t-- Cycle for every gene profile [END]');
		-- <<</ Ciclo per ogni profilo genico >>> --

	    if printOutputMatrix then f:close(); end;

    print('#APlistValueArray ' .. #APlistValueArray);
    print('#APlistGeneOidArray ' .. #APlistGeneOidArray);
    print('#APlistFeatureOidArray ' .. #APlistFeatureOidArray);
    apCount = apCount-1; -- togliamo l'ultimo incremento

    print('apCount ' .. apCount);

    -- for p=1,apCount do
    --  print(p ..') '..APlistValueArray[p] .. ' ' .. APlistGeneOidArray[p] .. ' '.. APlistFeatureOidArray[p]);
    -- end

	      require './funzioni/sort_two_arrays_from_first'
		  APListV = {}
		  APlistG = {}
		  APlistF = {}
		  APlistV, APlistG, APlistF =  sort_three_arrays_from_first(APlistValueArray, APlistGeneOidArray,  APlistFeatureOidArray, apCount);
		  
    -- print('#APlistV ' , #APlistV);
    -- print('#APlistG ' , #APlistG);
    -- print('#APlistF ' , #APlistF);

	  counter = 1;
	    for y=apCount, 1,-1 do
	      if printAPlist and counter<=topK then
		  f2:write("<annotation>\n");
		  f2:write("<entity_oid>" .. APlistG[y] .. "</entity_oid>\n");
		  f2:write("<term_oid>" .. APlistF[y] .. "</term_oid>\n");
		  f2:write("<prediction_value>" .. APlistV[y] .. "</prediction_value>\n");
		  f2:write("</annotation>\n");
		  f2:write('\n');
	      end	  
	      counter = counter+1;
	    end

		  
	    if printAPlist then
	      f2:write("</annotation_list>\n");
	      f2:write("</predicted_annotations>\n");
	      f2:close();
	    end  
	      
		  
    if printAucs then fAucs:close(); end



print('\n-:-:-:-:-:-:-:-:-:-:-\n')
-- print('experiment parameters:')
-- print(experiment);
print('-:-:-:-:-:-:-:-:-:-:-\n')

-- print('Da sistemare:\n');
-- print('+ il passo di threshold va messo a 0.001 anziche\' 0.01\n');

timeEnd = os.time();
durata = timeEnd - timeStart;
print('duration '.. tonumber(durata).. ' sec');

  
print('@ @ @ @ @ END @ @ @ @ @ ');

