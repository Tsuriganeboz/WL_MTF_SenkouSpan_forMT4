//+------------------------------------------------------------------+
//|                                            WL_MTF_SenkouSpan.mq4 |
//|                                    Copyright 2016, Tsuriganeboz  |
//|                                  https://github.com/Tsuriganeboz |
//+------------------------------------------------------------------+
#include <WL/WL_MTF_Ichimoku.mqh>
#include <WL/WL_Util.mqh>

#property copyright "Copyright 2016, Tsuriganeboz"
#property link      "https://github.com/Tsuriganeboz"
#property version   "1.00"
#property strict
#property indicator_chart_window

// インジケータ・バッファ最大数。
#property indicator_buffers 2

#property indicator_color1 Red
#property indicator_width1 5

#property indicator_color2 Blue
#property indicator_width2 5

//---
sinput int TimeFrame = 5;             // 時間軸

sinput int TenkanSenPeriod = 9;        // 転換線 期間
sinput int KijunSenPeriod = 26;        // 基準線 期間
sinput int SenkouSpanPeriod = 52;      // 先行スパンB 期間

sinput int ShiftPeriod = 26;           // 先行スパン シフト数

sinput color ColorSenkouSpanA = Red;   // 先行スパンA Color
sinput color ColorSenkouSpanB = Blue;   // 先行スパンB Color

sinput int IndicatorWidth = 5;          // 線幅

//---
double indSenkouSpanA[];
double indSenkouSpanB[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   if (Period() > TimeFrame)
      return (INIT_SUCCEEDED);
      
   int shiftPeriod = ShiftPeriod;
      
   SetIndexBuffer(0, indSenkouSpanA);
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, IndicatorWidth, ColorSenkouSpanA);
   SetIndexShift(0, shiftPeriod * (TimeFrame / Period()));

   SetIndexBuffer(1, indSenkouSpanB);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, IndicatorWidth, ColorSenkouSpanB);
   SetIndexShift(1, shiftPeriod * (TimeFrame / Period()));
   
   // 
   IndicatorShortName("MTF SenkouSpan(" + WL_GetTimeFrameString(TimeFrame) + ")");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   if (Period() > TimeFrame)
      return (rates_total);
      
   int limit = (Bars - IndicatorCounted());
       
   datetime timeArray[];
   int count = ArrayCopySeries(timeArray, MODE_TIME, Symbol(), TimeFrame);
   if (count == -1)
      return (rates_total);   
   
   
   double senkouSpanA = 0;
   double senkouSpanB = 0;
   bool isFirst = true;
   
   int timeFrameIndex = 0;
   for (int i = 0; i < limit; i++)
   {
      if (isFirst || Time[i] < timeArray[timeFrameIndex])
      {
         timeFrameIndex++;
         if (timeFrameIndex >= count)
            break;
         
         WL_MTFCalcIchimokuSenkouSpan(Symbol(), TimeFrame, timeFrameIndex,
                                       senkouSpanA, senkouSpanB);

         
         indSenkouSpanA[i] = senkouSpanA;      
         indSenkouSpanB[i] = senkouSpanB;
      }
      else
      {
         indSenkouSpanA[i] = senkouSpanA;      
         indSenkouSpanB[i] = senkouSpanB;      
      }
      
      isFirst = false;
   }   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
