//+------------------------------------------------------------------+
//|                                              WL_MTF_Ichimoku.mqh |
//|                                    Copyright 2016, Tsuriganeboz  |
//|                                  https://github.com/Tsuriganeboz |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, Tsuriganeboz"
#property link      "https://github.com/Tsuriganeboz"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| 初期処理　                                                          |
//+------------------------------------------------------------------+
void WL_MTFCalcIchimokuPrepare(string symbol, int timeFrame, int index,
                                 double& tenkanSenHigh, double& tenkanSenLow,
                                 double& kijunSenHigh, double& kijunSenLow,
                                 double& senkouSpanHigh, double& senkouSpanLow)
{

	tenkanSenHigh = iHigh(symbol, timeFrame, iHighest(symbol, timeFrame, MODE_HIGH, TenkanSenPeriod, index));
	tenkanSenLow = iLow(symbol, timeFrame, iLowest(symbol, timeFrame, MODE_LOW, TenkanSenPeriod, index));

	kijunSenHigh = iHigh(symbol, timeFrame, iHighest(symbol, timeFrame, MODE_HIGH, KijunSenPeriod, index));
	kijunSenLow = iLow(symbol, timeFrame, iLowest(symbol, timeFrame, MODE_LOW, KijunSenPeriod, index));

	senkouSpanHigh = iHigh(symbol, timeFrame, iHighest(symbol, timeFrame, MODE_HIGH, SenkouSpanPeriod, index));
	senkouSpanLow = iLow(symbol, timeFrame, iLowest(symbol, timeFrame, MODE_LOW, SenkouSpanPeriod, index));

/*
   double h = iHigh(symbol, timeFrame, index);
   double l = iLow(symbol, timeFrame, index);
  
   for (int i = (index + 1); i < (index + SenkouSpanPeriod); i++)
   {
      if (iHigh(symbol, timeFrame, i) > h)
         h = iHigh(symbol, timeFrame, i);
      
      if (iLow(symbol, timeFrame, i) < l)
         l = iLow(symbol, timeFrame, i);
      
      if (i == (index + TenkanSenPeriod) - 1)
      {
         tenkanSenHigh = h;
         tenkanSenLow = l;
      }
      else {}

      if (i == (index + KijunSenPeriod) - 1)
      {
         kijunSenHigh = h;
         kijunSenLow = l;
      }
      else {}
   }
   
   senkouSpanHigh = h;
   senkouSpanLow = l;
*/
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double WL_MTFCalcTenkanSen(double tenkanSenHigh, double tenkanSenLow)
{
   return (tenkanSenHigh + tenkanSenLow) / 2;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double WL_MTFCalcKijunSen(double kijunSenHigh, double& kijunSenLow)
{
   return (kijunSenHigh + kijunSenLow) / 2;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double WL_MTFCalcSenkouSpanA(double tenkanSen, double kijunSen)
{
   return (tenkanSen + kijunSen) / 2;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double WL_MTFCalcSenkouSpanB(double senkouSpanHigh, double senkouSpanLow)
{
   return (senkouSpanHigh + senkouSpanLow) / 2;
}

//+------------------------------------------------------------------+
//| 　　　　　　　　                                                         |
//+------------------------------------------------------------------+
void WL_MTFCalcIchimokuSenkouSpan(string symbol, int timeFrame, int index,
                                 double& senkouSpanA, double& senkouSpanB)
{
   double tenkanSenHigh = 0;
   double tenkanSenLow = 0;
   double kijunSenHigh = 0;
   double kijunSenLow = 0;
   double senkouSpanHigh = 0;
   double senkouSpanLow = 0;
   
   WL_MTFCalcIchimokuPrepare(symbol, timeFrame, index,
                              tenkanSenHigh, tenkanSenLow,
                              kijunSenHigh, kijunSenLow,
                              senkouSpanHigh, senkouSpanLow);
      
   
   double tenkanSen = WL_MTFCalcTenkanSen(tenkanSenHigh, tenkanSenLow);
   double kijunSen = WL_MTFCalcKijunSen(kijunSenHigh, kijunSenLow);

   senkouSpanA = WL_MTFCalcSenkouSpanA(tenkanSen, kijunSen);
   senkouSpanB = WL_MTFCalcSenkouSpanB(senkouSpanHigh, senkouSpanLow); 
}

//+------------------------------------------------------------------+
//| 　　　　　　　　                                                         |
//+------------------------------------------------------------------+
void WL_MTFCalcIchimokuKijunSenTenkanSen(string symbol, int timeFrame, int index,
                                       double& kijunSen, double& tenkanSen)
{
   double tenkanSenHigh = 0;
   double tenkanSenLow = 0;
   double kijunSenHigh = 0;
   double kijunSenLow = 0;
   double senkouSpanHigh = 0;
   double senkouSpanLow = 0;
   
   WL_MTFCalcIchimokuPrepare(symbol, timeFrame, index,
                              tenkanSenHigh, tenkanSenLow,
                              kijunSenHigh, kijunSenLow,
                              senkouSpanHigh, senkouSpanLow);
      
   
   tenkanSen = WL_MTFCalcTenkanSen(tenkanSenHigh, tenkanSenLow);
   kijunSen = WL_MTFCalcKijunSen(kijunSenHigh, kijunSenLow);
}
