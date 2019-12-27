module uim.core.datatypes.floating;

import uim.core;

@safe T fuzzy(T)(T value, T minLimit, T maxLimit, T minFactor = 0, T maxFactor = 1) if (isFloatingPoint!T) {
  if (value < minLimit) return minFactor;
  if (value > maxLimit) return maxFactor;
  
  return minFactor + (maxFactor - minFactor)*(value - minLimit)/(maxLimit - minLimit);   
}
unittest {
	
}
