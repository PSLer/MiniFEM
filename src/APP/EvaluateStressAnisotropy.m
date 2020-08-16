function handleVolume = EvaluateStressAnisotropy()
	global domainType_;
	global U_;
	global principalStressField_;
	PrincipalStress();
	if strcmp('2D', domainType_)
		ani = abs(principalStressField_(:,4)./principalStressField_(:,1));
	else
		ani = abs(principalStressField_(:,9)./principalStressField_(:,1));
	end
	ani = log10(ani);
	inVar = ScalarFieldForVolumeRendering();
	inVar.shiftingTerm = U_;
	inVar.scalingFac = 0;
	inVar.scalarFiled = ani;
	handleVolume = DirectlyVolumeRenderingScalarField(inVar);	
end