  
require 'os'

-- see if the file exists
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

-- tests the functions above
file = 'data/__stampa_matrice_BosTaurus9913-CC_prime10righe.txt';
lines = lines_from(file);

-- print all line numbers and their contents
for k,v in pairs(lines) do
    experiment = {}
    genes = {}
    features = {}
    annotations = {}
    if string.match(v,'experiment:') then
    --  print(v); 
      experiment = v;
      print(experiment);
    end
    if string.match(v,'genes:') then
      -- print(v); 
      genes = v;
      print(genes);
    end
    if string.match(v,'features:') then
      -- print(v); 
      features = v;
      print(features);
    end
end

print('genes[5]', genes[5]);
print('genes[7]', genes[7]);
print('features[5]', features[5]);