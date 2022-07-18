@EndUserText.label: 'CDS view for Goods Receipts (ID136)'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_ID136_ODATA_HANDLE'
define custom entity ZI_CLEARING_INVOICES 
{ 
  key DocumentNumber : abap.numc(10);
  Contract  : abap.numc(9);
  Vendor           : abap.char(10);
  TransactionName : abap.char(60);
  @Semantics.currencyCode
  Currency : abap.cuky(5);
  DocumentDate : abap.dats(8);
  @Semantics.amount.currencyCode: 'Currency'  
  GrossValue : abap.curr( 15, 2 );
  GrossValue_C : abap.char( 15 );
  @Semantics.amount.currencyCode: 'Currency'  
  NetValue : abap.curr( 15, 2 );
  NetValue_C : abap.char( 15 );
  @Semantics.amount.currencyCode: 'Currency'  
  WitholdingTax : abap.curr( 15, 2 );
  WitholdingTax_C : abap.char( 15 );
  @Semantics.amount.currencyCode: 'Currency'
  Vat : abap.curr( 15, 2 );
  Vat_C : abap.char( 15 );
  @Semantics.amount.currencyCode: 'Currency'  
  NetAndVat : abap.curr( 15, 2 );
  NetAndVat_C : abap.char( 15 );
  @Semantics.amount.currencyCode: 'Currency'  
  PaidToBank : abap.curr( 15, 2 );
  PaidToBank_C : abap.char( 15 );
  ClearingDocument : abap.char( 10 );
  DocumentType : abap.char(2);
  DocumentSubType : abap.char(5);
  FicoDocumentDate : abap.dats(8);
  FicoPostingDate : abap.dats(8);
  FicoSaveDate : abap.dats(8);
  _ContractFiData  : association to parent zi_contract_fi_data on $projection.Contract = _ContractFiData.Contract and $projection.Vendor = _ContractFiData.Vendor;
}
