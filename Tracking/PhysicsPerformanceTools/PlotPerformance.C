



void PlotPerformance()
{

  TFile *file = TFile::Open("/sphenix/sim/sim01/sphnxpro/TrackingDailyBuild/2023/29-07/MinBias50kHzHijingDailyBuild_g4svtx.root");
  
  TNtuple *tup = (TNtuple*)file->Get("ntp_gtrack");
  tup->Draw("gpt>>dummypt(30,0.2,30)");
  tup->Draw("gpt>>dummypt2(30,0.2,30)");
  tup->Draw("gpt>>dummypt3(30,0.2,30)");
  
  tup->Draw("gpt>>truthlowpt(19,0.1,2)","abs(gvz)<10 && abs(geta)<1.1 && gpt<=2");
  
  tup->Draw("gpt>>truthhighpt(28,2,30)","abs(gvz)<10 && abs(geta)<1.1 && gpt>2");
 
  tup->Draw("gpt>>recolowpt(19,0.1,2)","abs(gvz)<10 && abs(geta)<1.1 && gpt<=2 && ntpc>25 && quality<10");
  tup->Draw("gpt>>recohighpt(28,2,30)","abs(gvz)<10 && abs(geta)<1.1 && gpt>2 && ntpc>25 && quality<10");
  tup->Draw("gpt>>recolowptmaps(19,0.1,2)","abs(gvz)<10 && abs(geta)<1.1 && gpt<=2 && ntpc>25 && nmaps>2 && quality<10");
  tup->Draw("gpt>>recohighptmaps(28,2,30)","abs(gvz)<10 && abs(geta)<1.1 && gpt>2 && ntpc>25 && nmaps>2 && quality<10");
  tup->Draw("pt/gpt:gpt>>ptgr(4,0.2,1,200,0,2)","abs(gvz)<10 && abs(geta)<1.1 && ntpc>25 && nmaps>2 && quality<10 && gpt<1");
  tup->Draw("pt/gpt:gpt>>ptgr2(7,1,8,200,0,2)","abs(gvz)<10 && abs(geta)<1.1 && ntpc>25 && nmaps>2 && quality<10 && gpt>1 && gpt<8");
  tup->Draw("pt/gpt:gpt>>ptgr3(11,8,30,200,0,2)","abs(gvz)<10 && abs(geta)<1.1 && ntpc>25 && nmaps>2 && quality<10 && gpt>8");
  tup->Draw("dca3dxy:gpt>>dcax(9,0.2,2,50,-0.05,0.05)","abs(gvz)<10 && abs(geta)<1.1 && ntpc>25 && nmaps>2 && quality<10","colz");
  tup->Draw("dca3dz:gpt>>dcaz(9,0.2,2,50,-0.05,0.05)","abs(gvz)<10 && abs(geta)<1.1 && ntpc>25 && nmaps>2 && quality<10","colz");
tup->Draw("dca3dxy:gpt>>dcax2(14,2,30,50,-0.01,0.01)","abs(gvz)<10 && abs(geta)<1.1 && ntpc>25 && nmaps>2 && quality<10","colz");
  tup->Draw("dca3dz:gpt>>dcaz2(14,2,30,50,-0.01,0.01)","abs(gvz)<10 && abs(geta)<1.1 && ntpc>25 && nmaps>2 && quality<10","colz");
  


  /// The TH1s won't let you go past the x-axis bounds that
  /// they are defined within. So just draw a dummy histogram for 
  /// the initial canvas
  auto dummypt = (TH1*)gDirectory->Get("dummypt");
  auto dummypt2 = (TH1*)gDirectory->Get("dummypt2");
  auto dummypt3 = (TH1*)gDirectory->Get("dummypt3");
  auto truthlowpt = (TH1*)gDirectory->Get("truthlowpt");
  auto truthhighpt = (TH1*)gDirectory->Get("truthhighpt");
  auto recolowpt = (TH1*)gDirectory->Get("recolowpt");
  auto recohighpt = (TH1*)gDirectory->Get("recohighpt");
  auto recolowptmaps = (TH1*)gDirectory->Get("recolowptmaps");
  auto recohighptmaps = (TH1*)gDirectory->Get("recohighptmaps");
  auto ptgr = (TH2*)gDirectory->Get("ptgr");
  auto ptgr2 = (TH2*)gDirectory->Get("ptgr2");
  auto ptgr3 = (TH2*)gDirectory->Get("ptgr3");
  auto dcax = (TH2*)gDirectory->Get("dcax");
  auto dcaz = (TH2*)gDirectory->Get("dcaz");
  auto dcax2 = (TH2*)gDirectory->Get("dcax2");
  auto dcaz2 = (TH2*)gDirectory->Get("dcaz2");
  auto gaus = new TF1("gaus","gaus",0.8,1.2);
  ptgr->FitSlicesY(gaus);
  ptgr2->FitSlicesY(gaus);
  ptgr3->FitSlicesY(gaus);
  auto gaus2 = new TF1("gaus2","gaus",-0.01,0.01);
  dcax->FitSlicesY(gaus2);
  dcaz->FitSlicesY(gaus2);
  dcax2->FitSlicesY(gaus2);
  dcaz2->FitSlicesY(gaus2);
  auto ptgrw = (TH1*)gDirectory->Get("ptgr_2");
  auto ptgrw2 = (TH1*)gDirectory->Get("ptgr2_2");
  auto ptgrw3 = (TH1*)gDirectory->Get("ptgr3_2");
  auto dcaxw = (TH1*)gDirectory->Get("dcax_2");
  auto dcazw = (TH1*)gDirectory->Get("dcaz_2");
  auto dcaxw2 = (TH1*)gDirectory->Get("dcax2_2");
  auto dcazw2 = (TH1*)gDirectory->Get("dcaz2_2");

  dummypt->GetXaxis()->SetTitle("p_{T} [GeV]");
  dummypt->GetYaxis()->SetTitle("Efficiency");
  dummypt->GetXaxis()->SetRangeUser(0.21,20);
  dummypt->GetYaxis()->SetRangeUser(0,1);
  auto loweff = new TEfficiency(*recolowpt,*truthlowpt);
  auto higheff = new TEfficiency(*recohighpt,*truthhighpt);
  auto loweffm = new TEfficiency(*recolowptmaps, *truthlowpt);
  auto higheffm = new TEfficiency(*recohighptmaps, *truthhighpt);

  auto can = new TCanvas("can","can",200,200,800,600);
  loweff->SetMarkerColor(kRed);
  loweff->SetLineColor(kRed);
  higheff->SetLineColor(kRed);
  higheff->SetMarkerColor(kRed);
  dummypt->SetMarkerSize(0);
  dummypt->SetMarkerStyle(20);
   gStyle->SetOptStat(0);
  gPad->SetLogx();
  dummypt->Draw("p");
  higheff->Draw("psame");
  loweff->Draw("psame");
  loweffm->Draw("psame");
  higheffm->Draw("psame");
  
  TLegend *leg = new TLegend(0.4,0.2,0.6,0.5);
  leg->AddEntry((TObject*)0,"#bf{#it{sPHENIX}} simulation","");
  leg->AddEntry((TObject*)0,"50 kHz 0-20fm MB AuAu","");
  leg->AddEntry(loweff,"TPC tracks","P");
  leg->AddEntry(loweffm,"Silicon+TPC tracks","P");
  leg->SetTextSize(0.05);
  leg->Draw("same");


  auto can2 = new TCanvas("can2","can2",200,200,800,600);
  dummypt2->GetXaxis()->SetRangeUser(0.2,20);
  dummypt2->GetYaxis()->SetRangeUser(0,0.06);
  dummypt2->GetYaxis()->SetTitle("#sigma(p_{T})/p_{T}");
  dummypt2->GetXaxis()->SetTitle("p_{T} [GeV]");
  gPad->SetLogx();
  dummypt2->Draw();
  dummypt2->Draw();
  ptgrw->Draw("epsame");
  ptgrw2->Draw("epsame");
  ptgrw3->Draw("epsame");

  TLegend *leg2 = new TLegend(0.2,0.6,0.4,0.9);
  leg2->AddEntry((TObject*)0,"#bf{#it{sPHENIX}} simulation","");
  leg2->AddEntry((TObject*)0,"50 kHz 0-20fm MB AuAu","");
  leg2->AddEntry((TObject*)0,"nTPC>25 && nMVTX>2","");
  leg2->SetTextSize(0.05);
  leg2->Draw("same");

  auto can3 = new TCanvas("can3","can3",200,200,800,600);
  dcazw->SetMarkerColor(kRed);
  dcazw->SetLineColor(kRed);
  dcazw2->SetMarkerColor(kRed);
  dcazw2->SetLineColor(kRed);
  dummypt3->GetXaxis()->SetRangeUser(0.5,20);
  dummypt3->GetYaxis()->SetRangeUser(0,0.01);
  dummypt3->GetYaxis()->SetTitle("#sigma(DCA) [cm]");
  dummypt3->GetXaxis()->SetTitle("p_{T} [GeV]");
  gPad->SetLogx();
  dummypt3->Draw();
  dcaxw->Draw("epsame");
  dcazw->Draw("epsame");
  dcaxw2->Draw("epsame");
  dcazw2->Draw("epsame");


  TLegend *leg3 = new TLegend(0.4,0.6,0.6,0.9);
  leg3->AddEntry((TObject*)0,"#bf{#it{sPHENIX}} simulation","");
  leg3->AddEntry((TObject*)0,"50 kHz 0-20fm MB AuAu","");
  leg3->AddEntry((TObject*)0,"nTPC>25 && nMVTX>2","");
  leg3->AddEntry(dcaxw,"DCA_{xy}","P");
  leg3->AddEntry(dcazw,"DCA_{z}","P");
  leg3->SetTextSize(0.05);
  leg3->Draw("same");
}
