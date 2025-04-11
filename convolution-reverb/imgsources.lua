--####################################################################--
--#                                                                  #--
--# Acoustical Impulse Response Evaluation With Image Sources Method #--
--#                                                                  #--
--####################################################################--

-- source position
function p(L,f,n)
  local pos
  pos = 2*L*math.floor((n+1)/2) + f*((-1)^n)
  return pos
end


function zeros(dim)
  local array = {}
  for j = 1,dim do
    array[j] = 0
  end
  return array
end

-- Variable names are slightly changed
-- 'e' and 'd' are the Portuguese initials for left and right
function evaluate(X,Y,Z,oex,oey,oez,odx,ody,odz,fx,fy,fz,v,N,am,fs,m)
  local pxm = 2*X*math.floor((N+1)/2) + fx -- max x virtual source
  local pym = 2*Y*math.floor((N+1)/2) + fy -- max y virtual source
  local pzm = 2*Z*math.floor((N+1)/2) + fz -- max z virtual source
  
  local px,py,pz,ce,cd,ae,ad,te,td
  
  local Te_max = fs*(math.sqrt((pxm-oex)^2 + (pym-oey)^2 + (pzm-oez)^2))/v -- max instant index
  local Td_max = fs*(math.sqrt((pxm-odx)^2 + (pym-ody)^2 + (pzm-odz)^2))/v -- max instant index
  
  local Ae = zeros(math.ceil(Te_max)) -- left ear amplitude pressure (IR)
  local Ad = zeros(math.ceil(Td_max)) -- right ear amplitude pressure (IR)
  
  local t = 0
  
  for i = -N,N do
    for j = -N,N do
      for k = -N,N do
        if ((math.abs(i) + math.abs(j) + math.abs(k)) <= N) then
          px = p(X,fx,i) -- x virtual source
          py = p(Y,fy,j) -- y virtual source
          pz = p(Z,fz,k) -- z virtual source
      
          ce = math.sqrt((px-oex)^2 + (py-oey)^2 + (pz-oez)^2) -- left ear path
          cd = math.sqrt((px-odx)^2 + (py-ody)^2 + (pz-odz)^2) -- right ear path
      
      	  ph = (-1)^(i + j + k) -- phase
      
          ae = ph*((1-am)^(math.abs(i) + math.abs(j) + math.abs(k)))/ce -- left ear instant amplitude pressure
          ad = ph*((1-am)^(math.abs(i) + math.abs(j) + math.abs(k)))/cd -- right ear instant amplitude pressure
      
          te = math.ceil(fs*ce/v) -- left ear path
          td = math.ceil(fs*cd/v) -- right ear path
          
          ae = ae*math.exp(-m*ce) -- left ear air absorption effect
          ad = ae*math.exp(-m*cd) -- right ear air absorption effect
      
          Ae[te] = Ae[te] + ae -- left ear impulse response (IR)
          Ad[td] = Ad[td] + ad -- right ear impulse response (IR)
        end
      end
    end
    pd.post("[OK] from iteration "..t.."\n")
    t = t + 1
  end
  
  return Ae, Ad


end


-----------------------------------------------------------------------------------------------------------------


pd.post("\nAcoustical Impulse Response Evaluation With Image Sources Method\n")


local imgsources = pd.Class:new():register("imgsources")


function imgsources:initialize(name,atoms)
  -- code
  self.inlets = 1 -- lista de valores no Pd
  self.outlets = 4 -- canal direito e esquerdo e tamanhos das respostas
  return true
end


function imgsources:in_1_list(l)
  self.X, self.Y, self.Z = l[1], l[2], l[3] -- room dimensions (m)
  self.oex, self.oey, self.oez = l[4], l[5], l[6] -- left ear position (m)
  self.odx, self.ody, self.odz = l[7], l[8], l[9] -- right ear position (m)
  self.fx, self.fy, self.fz = l[10], l[11], l[12] -- source position (m)
  self.v, self.N, self.am = l[13], l[14], l[15] -- speed of sound (m/s), order of reflection, average absorption
  self.fs = l[16] -- sampling frequency (Hz)
  self.m = l[17] -- air absorption index
end


function imgsources:in_1_bang()
  pd.post("\n[OK] Started...\n")
  self.Ae, self.Ad = evaluate(self.X,self.Y,self.Z,self.oex,self.oey,self.oez,self.odx,self.ody,self.odz,self.fx,self.fy,self.fz,self.v,self.N,self.am,self.fs,self.m)
  self:outlet(3,"float",{#self.Ae})
  self:outlet(4,"float",{#self.Ad})
  for j = 1, #self.Ae do
    self:outlet(1,"float",{self.Ae[j]})
  end
  for j = 1, #self.Ad do
    self:outlet(2,"float",{self.Ad[j]})
  end
end


function imgsources:finalize()
  pd.post("\n...destruct...!\n")
end

