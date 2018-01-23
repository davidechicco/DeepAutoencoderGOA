

-- Esempio preso dal web per capire cosa s'intende per "closure" 

-- http://greendotblade3.cs.nyu.edu/torch/tutorial/index.html

-- Functions
--
-- A few more things about functions: functions in Lua are proper closures,
-- so in combination with tables, you can use them to build complex and very flexible programs. 
-- An example of closure is given here: 

myfuncs = {} -- dichiarazione d'un vettore

for i = 1,4 do
  
    local calls = 0 -- dichiarazione e inizializzazione di variabile
    
    myfuncs[i] = function() -- dichiarazione d'inizio di corpo di funzione (il corpo della funzione finira' all'end indentato). Nessun parametro in input.
        calls = calls + 1
        print('this function has been called ' .. calls .. ' times')
    end	-- fine del corpo della funzione
    
end
print('end for');

print('--- running myfuncs[1] ---')
myfuncs[1]() -- viene chiamata la funzione myfuncs() relativa all'elemento i, che e' gia' stata salvata nell'elemento myfuncs[1] dell'array
print('--- running myfuncs[1] ---')
myfuncs[1]()

-- myfuncs[n]() e' un oggetto sia elemento d'array sia una funzione.
-- Puo' essere interpretato come un elemento dell'array che contiene le istruzioni della funzione, che quando viene chiamato lui usa.
-- E puo' anche essere inteso come una chiamata alla funzione numerata 1, senza parametri in input.
