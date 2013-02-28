function mutualInfo = mutualInformation(a, b)
  % two row vectors are expected!
  counts = [a; b];
  pXY = counts./sum(counts(:));
  pX = sum(pXY,2);
  pY = sum(pXY,1);

  mutualInfo = pXY.*log(pXY./(pX*pY));
  mutualInfo = sum(mutualInfo(:));

end