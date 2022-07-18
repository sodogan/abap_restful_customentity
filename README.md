# abap_restful_customentity for ODATA V4 is done here

ABAP restfull implementation with Restful via the Custom Entities

All of the entities are custom entitities and theres a parent and child relationship.
The root enitity is: ZI_VENDOR_FI_TRANSACTION
The data is at SAp client 500

Here are a few scenarios how to test service with URL:

1. When you put Vendor (required) and Contract (optional), example (you can swap the values marked as bold):

https://mgrciwsd.sap.mgr.ads:44300/sap/opu/odata4/sap/zapi_vendorfitrans_id136/srvd_a2x/sap/zapi_vendorfitransaction/0001/ContractFiData?sap-client=500

https://mgrciwsd.sap.mgr.ads:44300/sap/opu/odata4/sap/zapi_vendorfitrans_id136/srvd_a2x/sap/zapi_vendorfitransaction/0001/VendorFiTransaction?sap-client=500&$expand=_ContractFiData&$filter=Vendor%20eq%20%27M1871423%27

https://mgrciwsd.sap.mgr.ads:44300/sap/opu/odata4/sap/zapi_vendorfitrans_id136/srvd_a2x/sap/zapi_vendorfitransaction/0001/VendorFiTransaction?sap-client=500&$expand=_ContractFiData($expand=_GoodsReceipts)&$filter=Vendor%20eq%20%27M1871423%27

https://mgrciwsd.sap.mgr.ads:44300/sap/opu/odata4/sap/zapi_vendorfitrans_id136/srvd_a2x/sap/zapi_vendorfitransaction/0001/VendorFiTransaction?sap-client=500&$expand=_ContractFiData($expand=_GoodsReceipts,_Payments,_CoopInvestments,_OrderedPrepayments,_SalesPromotions,_ClearingInvoices),_ContractList&$filter=Vendor eq 'M1871423' and Contract eq '0950151061'

2. Similar to the above but you can also list multiple Contracts in filter, for example:

https://mgrciwsd.sap.mgr.ads:44300/sap/opu/odata4/sap/zapi_vendorfitrans_id136/srvd_a2x/sap/zapi_vendorfitransaction/0001/VendorFiTransaction?sap-client=500&$expand=_ContractFiData($expand=_GoodsReceipts,_Payments,_CoopInvestments,_OrderedPrepayments,_SalesPromotions,_ClearingInvoices),_ContractList&$filter=Vendor eq 'M1871423' and (Contract eq '0950151061' or Contract eq '0950152052')

3. When you only put Vendor (required), you will got all contracts for this vendor, example:

https://mgrciwsd.sap.mgr.ads:44300/sap/opu/odata4/sap/zapi_vendorfitrans_id136/srvd_a2x/sap/zapi_vendorfitransaction/0001/VendorFiTransaction?sap-client=500&$expand=_ContractFiData($expand=_GoodsReceipts,_Payments,_CoopInvestments,_OrderedPrepayments,_SalesPromotions,_ClearingInvoices),_ContractList&$filter=Vendor eq 'M1871423'

4. You can of course adjust the URL according to OData specification and remove some paths from expand, for example if you don't want \_ContractList data and \_SalesPromotions in the results, it would look like that (this doesn't affect performance, because the all data is calculated anyway in one single functon module):

https://mgrciwsd.sap.mgr.ads:44300/sap/opu/odata4/sap/zapi_vendorfitrans_id136/srvd_a2x/sap/zapi_vendorfitransaction/0001/VendorFiTransaction?sap-client=500&$expand=_ContractFiData($expand=_GoodsReceipts,_Payments,_CoopInvestments,_OrderedPrepayments,_ClearingInvoices)&$filter=Vendor eq 'M1871423'
