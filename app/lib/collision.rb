def box_box?(b1, b2) 
  b1[:x] + b1[:w] > b2[:x] && 
  b2[:x] + b2[:w] > b1[:x] &&
  b1[:y] + b1[:h] > b2[:y] &&
  b2[:y] + b2[:h] > b1[:y] 
end

def box_circle?(b, c)
  xnear = [b[:x], b[:w] + b[:x], c[:x]].sort[1]
  ynear = [b[:y], b[:h] + b[:y], c[:y]].sort[1]
  
  sqdist = (xnear - c[:x]) * (xnear - c[:x]) + (ynear - c[:y]) * (ynear - c[:y]) 
  sqdist < c[:r] * c[:r]
end

def point_circle?(p, c)
  sqdist = (p[:x] - c[:x]) * (p[:x] - c[:x]) + (p[:y] - c[:y]) * (p[:y] - c[:y])
  sqdist < (p[:r] * p[:r])
end

def circle_circle?(c1, c2)
  sqdist = (c1[:x] - c2[:x]) * (c1[:x] - c2[:x]) + (c1[:y] - c2[:y]) * (c1[:y] - c2[:y]) 
  sqdist < (c1[:r] + c2[:r]) * (c1[:r] + c2[:r])
end
