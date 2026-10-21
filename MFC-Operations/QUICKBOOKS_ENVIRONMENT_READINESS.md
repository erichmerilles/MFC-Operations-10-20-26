# QuickBooks Environment Readiness

**Reviewed:** 2026-10-21  
**Decision:** NO-GO for any posting test until all Critical and High items below are closed.

## Evidence classes

- **Verified in repository/local DB:** supported by inspected source/schema or the recorded read-only inventory dated 2026-10-20.
- **Official product behavior:** supported by the linked Intuit documentation, but not by a test of this deployment.
- **Unverified:** requires the system owner or authorized QuickBooks operator to confirm in the intended environment.

## Readiness matrix

| Area | Current evidence | Status / severity | Required evidence to close |
|---|---|---|---|
| Target edition | Settings/docs name QuickBooks Desktop Enterprise Solutions 24.0. | **Unverified / Critical** | Screenshot or operator confirmation of installed edition, release/build, country/region and company-file version. |
| Intended company file | No company file path, identity, owner or test file in source. | **Unverified / Critical** | Named, authorized isolated test company and confirmation of correct file when QBWC connects. Do not put private path/credentials in reports. |
| Web Connector | No `.qwc`, QBWC SOAP endpoint or service methods found. | **Absent in repository / Critical** | Confirm host machine and QBWC installation/version; provide controlled operator access for a later implementation/test phase. |
| Hosting / reachability | No service endpoint or deployment topology verified. | **Unverified / Critical** | Confirm where PHP service runs, HTTPS/TLS certificate, DNS/routing, outbound/inbound restrictions, and whether QBWC can reach endpoint. |
| Authorization | Local app auth exists; QB company authorization to the future web service is untested. | **Unverified / Critical** | Approve QuickBooks user/company permissions and QBWC authorization scope in the test company. Least privilege. |
| qbXML version | No request version is implemented or selected. | **Unverified / High** | Select only after matching installed QuickBooks Desktop and SDK/OSR, then validate schemas and requests in the test company. |
| Customer mapping | No customer export file was found among repository CSV/XLSX/XML/QWC assets. Local inventory: 819 clients, 816 active, all 816 active missing legacy QB ListID. | **Blocked / Critical** | Export authoritative customer FullNames and state from approved company; verify exact/unambiguous query against local client names. FullName references can avoid local ListID storage; absent ListID alone is not a blocker. |
| Item mapping | Local inventory: 94 products (92 active, 2 inactive); all 92 active lack legacy QB ListID; 18 also lack QB Code and QB Description. | **Blocked / Critical** | Export item FullName, code/other identifiers, type, active status and relevant U/M from approved company; verify each code-to-item association. Do not assume `qb_code` equals FullName. |
| Lifecycle / availability | No per-product stock or discontinued/phased-out state exists in reviewed schema. | **Unknown / High** | Authorized, product-level lifecycle/availability decision. Do not infer from missing mappings or app `active`. Map only items actually used by eligible transactions. |
| Tax, classes and custom fields | App local tax values `Non`/`Tax`/`Exempt` and local site/lot/U/M/class/status/fulfilled/expiry fields are not company-file verified. | **Unverified / High** | Confirm company preference, tax items/codes, class list, custom fields, item types and supported transaction-line elements. |
| Credentials/secrets | No connector secret/config was found in code. | **Unverified / High** | Define storage, rotation, access, redaction and backup procedure before service configuration. Never commit/export secrets. |
| Duplicate/uncertain recovery | Status/schema clues exist for invoices, but no worker, atomic claim, response reconciliation or SO job model. | **Not implemented / Critical** | Design and test idempotency, Unknown outcome handling, reconciliation before retry, immutable attempt history and transaction-specific status. |

## Official Web Connector facts and limits

Intuit describes QBWC as a Windows intermediary that passes qbXML between a web service and QuickBooks Desktop, installed on the QuickBooks machine or at least the same local network. The QBWC initiates communications and the web service implements WSDL-defined methods. A `.qwc` file describes a service for QBWC. This confirms the broad product architecture; it does **not** establish that this application, its network, selected QBWC build, company file or authentication will work. See [Intuit: Get started with QuickBooks Web Connector](https://static.developer.intuit.com/output_html/qbdesktop/docs/get-started/get-started-with-quickbooks-web-connector.html).

Intuit's SDK guide includes FullName examples for customer and item references in InvoiceAdd/SalesOrderAdd; this demonstrates supported name-based references in the documented API, not identity verification of MFC records. Future code must use the intended transaction type and matching OSR. See [QBSDK Programmer's Guide](https://static.developer.intuit.com/qbSDK-current/doc/pdf/QBSDK_ProGuide.pdf), [InvoiceAdd](https://developer.intuit.com/app/developer/qbdesktop/docs/api-reference/qbdesktop/invoiceadd), and [SalesOrderAdd](https://developer.intuit.com/app/developer/qbdesktop/docs/api-reference/qbdesktop/salesorderadd). No request was sent to the intended company file, and exact query/response behavior remains unverified there.

## Operator confirmations needed

1. Which exact QuickBooks Desktop Enterprise release/build, regional edition, and company file is the target? Is there an isolated test company?
2. Which Windows machine runs QuickBooks and QBWC? Which QBWC/SDK version is installed and who can authorize the service?
3. Where will the PHP app/service run, and can that host serve a reachable HTTPS endpoint compatible with the connector?
4. Can an authorized operator export customer and item identifiers from the intended company, including ListID and FullName (and item/customer active state/type)?
5. Which transactions/products are in scope now? Which incomplete products are genuinely used by current draftable withdrawals versus obsolete/unneeded?
6. Who approves invoice footer Memo, PO, tax handling, class, unit, site/lot, status, fulfilled quantity and expiry field decisions?
7. What is the approved recovery authority for an Unknown outcome, and who is allowed to query/reconcile before any retry?

No credential, company identity, endpoint, authorization, transaction or QuickBooks result is established by this audit.
