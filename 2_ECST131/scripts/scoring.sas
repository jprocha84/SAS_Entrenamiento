*****************************************;
** SAS Scoring Code for PROC PLM;
*****************************************;

label P_SalePrice = 'Predicted: SalePrice' ;
drop _LMR_BAD;
_LMR_BAD=0;

*** Check interval variables for missing values;
if nmiss(Gr_Liv_Area,Basement_Area,Garage_Area,Deck_Porch_Area,Lot_Area,
        Age_Sold,Bedroom_AbvGr,Total_Bathroom) then do;
   _LMR_BAD=1;
   goto _SKIP_010;
end;

*** Generate design variables for Overall_Qual2;
drop _1_0 _1_1 _1_2 ;
_1_0= 0;
_1_1= 0;
_1_2= 0;
length _st12 $ 12; drop _st12;
_st12 = left(trim(put (Overall_Qual2, BEST12.0)));
if _st12 = '5'  then do;
   _1_0 = 1;
end;
else if _st12 = '6'  then do;
   _1_1 = 1;
end;
else if _st12 = '4'  then do;
   _1_2 = 1;
end;
else do;
   _1_0 = .;
   _1_1 = .;
   _1_2 = .;
   _LMR_BAD=1;
   goto _SKIP_010;
end;

*** Generate design variables for Overall_Cond2;
drop _2_0 _2_1 _2_2 ;
_2_0= 0;
_2_1= 0;
_2_2= 0;
length _st12 $ 12; drop _st12;
_st12 = left(trim(put (Overall_Cond2, BEST12.0)));
if _st12 = '5'  then do;
   _2_0 = 1;
end;
else if _st12 = '6'  then do;
   _2_1 = 1;
end;
else if _st12 = '4'  then do;
   _2_2 = 1;
end;
else do;
   _2_0 = .;
   _2_1 = .;
   _2_2 = .;
   _LMR_BAD=1;
   goto _SKIP_010;
end;

*** Generate design variables for Fireplaces;
drop _3_0 _3_1 _3_2 ;
_3_0= 0;
_3_1= 0;
_3_2= 0;
length _st12 $ 12; drop _st12;
_st12 = left(trim(put (Fireplaces, BEST12.0)));
if _st12 = '1'  then do;
   _3_0 = 1;
end;
else if _st12 = '2'  then do;
   _3_1 = 1;
end;
else if _st12 = '0'  then do;
   _3_2 = 1;
end;
else do;
   _3_0 = .;
   _3_1 = .;
   _3_2 = .;
   _LMR_BAD=1;
   goto _SKIP_010;
end;

*** Generate design variables for Heating_QC;
drop _7_0 _7_1 _7_2 _7_3 ;
_7_0= 0;
_7_1= 0;
_7_2= 0;
_7_3= 0;
length _st2 $ 2; drop _st2;
_st2 = left(trim(put (Heating_QC, $CHAR2.0)));
if _st2 = 'Fa'  then do;
   _7_0 = 1;
end;
else if _st2 = 'Gd'  then do;
   _7_1 = 1;
end;
else if _st2 = 'TA'  then do;
   _7_2 = 1;
end;
else if _st2 = 'Ex'  then do;
   _7_3 = 1;
end;
else do;
   _7_0 = .;
   _7_1 = .;
   _7_2 = .;
   _7_3 = .;
   _LMR_BAD=1;
   goto _SKIP_010;
end;

*** Generate design variables for Masonry_Veneer;
drop _8_0 _8_1 ;
_8_0= 0;
_8_1= 0;
length _st1 $ 1; drop _st1;
_st1 = left(trim(put (Masonry_Veneer, $CHAR1.0)));
if _st1 = 'Y'  then do;
   _8_0 = 1;
end;
else if _st1 = 'N'  then do;
   _8_1 = 1;
end;
else do;
   _8_0 = .;
   _8_1 = .;
   _LMR_BAD=1;
   goto _SKIP_010;
end;

*** Generate design variables for Lot_Shape_2;
drop _9_0 _9_1 ;
_9_0= 0;
_9_1= 0;
length _st10 $ 10; drop _st10;
_st10 = left(trim(put (Lot_Shape_2, $CHAR10.0)));
if _st10 = 'Regular'  then do;
   _9_0 = 1;
end;
else if _st10 = 'Irregular'  then do;
   _9_1 = 1;
end;
else do;
   _9_0 = .;
   _9_1 = .;
   _LMR_BAD=1;
   goto _SKIP_010;
end;

*** Compute Linear Predictors;
drop _LP0;
_LP0 = 0;

*** Effect: Overall_Qual2;
_LP0 = _LP0 + (6782.08026335631) * _1_0;
_LP0 = _LP0 + (13659.268105391) * _1_1;
*** Effect: Overall_Cond2;
_LP0 = _LP0 + (8996.6180200037) * _2_0;
_LP0 = _LP0 + (15909.0589761631) * _2_1;
*** Effect: Fireplaces;
_LP0 = _LP0 + (9716.20592451268) * _3_0;
_LP0 = _LP0 + (7235.6616186997) * _3_1;
*** Effect: Heating_QC;
_LP0 = _LP0 + (-11667.6811780935) * _7_0;
_LP0 = _LP0 + (-3178.91839042385) * _7_1;
_LP0 = _LP0 + (-6689.24712599403) * _7_2;
*** Effect: Masonry_Veneer;
_LP0 = _LP0 + (-3369.65262228732) * _8_0;
*** Effect: Lot_Shape_2;
_LP0 = _LP0 + (-4507.71544708141) * _9_0;
*** Effect: Gr_Liv_Area;
_LP0 = _LP0 + (42.9721940222413) * Gr_Liv_Area;
*** Effect: Basement_Area;
_LP0 = _LP0 + (25.4912732941362) * Basement_Area;
*** Effect: Garage_Area;
_LP0 = _LP0 + (29.6985561954518) * Garage_Area;
*** Effect: Deck_Porch_Area;
_LP0 = _LP0 + (20.9525612375151) * Deck_Porch_Area;
*** Effect: Lot_Area;
_LP0 = _LP0 + (1.19985759882172) * Lot_Area;
*** Effect: Age_Sold;
_LP0 = _LP0 + (-422.187733226867) * Age_Sold;
*** Effect: Bedroom_AbvGr;
_LP0 = _LP0 + (-4541.12499746154) * Bedroom_AbvGr;
*** Effect: Total_Bathroom;
_LP0 = _LP0 + (3806.35123684253) * Total_Bathroom;

*** Predicted values;
_LP0 = _LP0 +     51206.6225594024;
_SKIP_010:
if _LMR_BAD=1 then do;
   P_SalePrice = .;
end;
else do;
   P_SalePrice = _LP0;
end;
