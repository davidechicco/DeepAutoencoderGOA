  
require 'os'

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

 -- open the files
file = 'data/__stampa_matrice_BosTaurus9913-CC_prime10righe.txt';
-- file = 'data/prova.txt'
lines = lines_from(file); -- we take the lines

    experiment = {}
    genes = {}
    features = {}
    annotations = {}

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
	gene_profile[gA] =  tonumber(token);
	--print('gA' .. gA .. ' ' ..token);
	 gA=gA+1;
	 --print('gene_profile['.. gA ..']', gene_profile[gA]);
	end
      end
    annotations[gpNum] = gene_profile;
     -- print('annotations[' .. gpNum .. ']',  annotations[gpNum]);
    
    end
   
    gpNum = gpNum + 1;
end

local f,err = io.open("ciao.txt","w")
if not f then return print(err) end

-- ATTENZIONE: il numero di geni va da 0 a #genes-1, mentre il numero di caratteristiche va da 1 a #features

for i=0,(#genes-1) do
   f:write('\n');
      for j=1,(#features) do
      --print('annotations[' .. i .. '][' .. j .. ']',  annotations[i][j]);
     --print('annotations[' .. i .. ']',  annotations[i]);
         f:write(annotations[i][j] .. ' '); -- sono uguali, perfetto!
    end
 end
-- f:writeObject(annotations);
f:close()
 
--print(annotations[9]);	

-- for i=0,#genes-1 do
--   print('genes[' .. i .. ']',  genes[i]);
-- end
-- 
-- for i=0,#features-1 do
--   print('features[' .. i .. ']', features[i]);
-- end
-- 
-- print('#genes', #genes);
-- print('#features', #features);
