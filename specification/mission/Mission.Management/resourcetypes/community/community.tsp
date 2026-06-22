// cspell:enableCompoundWords
// cspell:words managedonbehalfofconfiguration

import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "@typespec/versioning";
import "../shared/maintenancemodeconfiguration.tsp";

using Azure.ResourceManager;
using TypeSpec.Versioning;
using Azure.Core;

@doc("Microsoft Mission Resource Provider management API.")
namespace Microsoft.Mission;

@doc("Azure Firewall SKU")
union FirewallSKU {
  string,

  @doc("FirewallSKU Basic")
  Basic: "Basic",

  @doc("FirwallSKU Standard")
  Standard: "Standard",

  @doc("FirewallSKU Premium")
  Premium: "Premium",
}

@added(Microsoft.Mission.Versions.v2024_12_01_preview)
@doc("Approval Policy.")
union ApprovalPolicy {
  string,

  @doc("Approval will be required for the specified action.")
  Required: "Required",

  @doc("Approval will not be required for the specified action.")
  NotRequired: "NotRequired",
}

@added(Microsoft.Mission.Versions.v2024_12_01_preview)
@doc("Approver Metadata for approvals request.")
model MandatoryApprover {
  @doc("EntraId of the approver")
  approverEntraId: string;
}

@added(Microsoft.Mission.Versions.v2025_11_01_preview)
@doc("Granular approval setting configuration with policy, minimum approvers, and mandatory approvers.")
model ApprovalSettingConfiguration {
  @doc("Approval policy (Required or NotRequired).")
  approvalPolicy?: ApprovalPolicy;

  @doc("Minimum number of approvers required for this approval setting.")
  minimumApproversRequired?: int64;

  @identifiers(#["approverEntraId"])
  @doc("List of mandatory approvers for this approval setting.")
  mandatoryApprovers?: MandatoryApprover[];
}

@added(Microsoft.Mission.Versions.v2024_12_01_preview)
@doc("ApprovalSettings Properties")
model ApprovalSettings {
  @doc("Approval required for endpoint creation (Required or NotRequired).")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @removed(Microsoft.Mission.Versions.v2025_11_01_preview)
  endpointCreation?: ApprovalPolicy;

  @doc("Approval required for endpoint update (Required or NotRequired).")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @removed(Microsoft.Mission.Versions.v2025_11_01_preview)
  endpointUpdate?: ApprovalPolicy;

  @doc("Approval required for endpoint deletion (Required or NotRequired).")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @removed(Microsoft.Mission.Versions.v2025_11_01_preview)
  endpointDeletion?: ApprovalPolicy;

  @doc("Approval required for enclave connection creation (Required or NotRequired).")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @typeChangedFrom(
    Microsoft.Mission.Versions.v2025_11_01_preview,
    ApprovalPolicy
  )
  connectionCreation?: ApprovalSettingConfiguration;

  @doc("Approval required for enclave connection update (Required or NotRequired).")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @typeChangedFrom(
    Microsoft.Mission.Versions.v2025_11_01_preview,
    ApprovalPolicy
  )
  connectionUpdate?: ApprovalSettingConfiguration;

  @doc("Approval required for enclave connection deletion (Required or NotRequired).")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @removed(Microsoft.Mission.Versions.v2025_11_01_preview)
  connectionDeletion?: ApprovalPolicy;

  @doc("Approval required for virtual enclave creation (Required or NotRequired).")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @typeChangedFrom(
    Microsoft.Mission.Versions.v2025_11_01_preview,
    ApprovalPolicy
  )
  enclaveCreation?: ApprovalSettingConfiguration;

  @doc("Approval required for virtual enclave deletion (Required or NotRequired).")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @removed(Microsoft.Mission.Versions.v2025_11_01_preview)
  enclaveDeletion?: ApprovalPolicy;

  @doc("Approval required for toggling maintenance mode (Required or NotRequired).")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @removed(Microsoft.Mission.Versions.v2025_11_01_preview)
  maintenanceMode?: ApprovalPolicy;

  @doc("Approval required for deploying service catalog templates (Required or NotRequired).")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @removed(Microsoft.Mission.Versions.v2025_11_01_preview)
  serviceCatalogDeployment?: ApprovalPolicy;

  @added(Microsoft.Mission.Versions.v2024_12_01_preview)
  @doc("Notification will be sent on creation of an Approval Request")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @removed(Microsoft.Mission.Versions.v2025_11_01_preview)
  notificationOnApprovalCreation?: ApprovalPolicy;

  @added(Microsoft.Mission.Versions.v2024_12_01_preview)
  @doc("Notification will be sent on any action taken (Approve/Reject) on an Approval Request")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @removed(Microsoft.Mission.Versions.v2025_11_01_preview)
  notificationOnApprovalAction?: ApprovalPolicy;

  @added(Microsoft.Mission.Versions.v2024_12_01_preview)
  @doc("Notification will be sent on deletion of an Approval Request")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @removed(Microsoft.Mission.Versions.v2025_11_01_preview)
  notificationOnApprovalDeletion?: ApprovalPolicy;

  @added(Microsoft.Mission.Versions.v2024_12_01_preview)
  @identifiers(#["approverEntraId"])
  @doc("List of mandatory approvers for the approval request")
  @removed(Microsoft.Mission.Versions.v2025_11_01_preview)
  mandatoryApprovers?: MandatoryApprover[];

  @added(Microsoft.Mission.Versions.v2024_12_01_preview)
  @doc("Minimum number of approvers required for the approval request")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  @removed(Microsoft.Mission.Versions.v2025_11_01_preview)
  minimumApproversRequired?: int64;

  @added(Microsoft.Mission.Versions.v2025_11_01_preview)
  @doc("Approval configuration for community endpoint updates.")
  communityEndpointUpdate?: ApprovalSettingConfiguration;

  @added(Microsoft.Mission.Versions.v2025_11_01_preview)
  @doc("Approval configuration for enclave endpoint updates.")
  enclaveEndpointUpdate?: ApprovalSettingConfiguration;

  @added(Microsoft.Mission.Versions.v2025_11_01_preview)
  @doc("Approval configuration for community maintenance mode.")
  communityMaintenanceMode?: ApprovalSettingConfiguration;

  @added(Microsoft.Mission.Versions.v2025_11_01_preview)
  @doc("Approval configuration for enclave maintenance mode.")
  enclaveMaintenanceMode?: ApprovalSettingConfiguration;
}

@added(Microsoft.Mission.Versions.v2024_12_01_preview)
@doc("ApprovalSettings Properties")
model ApprovalSettingsPatchProperties
  is UpdateableProperties<OmitDefaults<ApprovalSettings>>;

@doc("Community Resource Properties")
model CommunityBaseModel {
  @doc("Address Space.")
  @visibility(Lifecycle.Read, Lifecycle.Create)
  addressSpace?: string;

  @doc("DNS Servers.")
  dnsServers?: string[];

  @doc("Provisioning State.")
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  @doc("List of resource ids created by communities.")
  @visibility(Lifecycle.Read)
  @typeChangedFrom(Microsoft.Mission.Versions.v2025_05_01_preview, string[])
  resourceCollection?: armResourceIdentifier[];

  @doc("Managed resource group name.")
  @visibility(Lifecycle.Read)
  @renamedFrom(
    Microsoft.Mission.Versions.v2025_05_01_preview,
    "managedResourceGroupConfiguration"
  )
  @typeChangedFrom(
    Microsoft.Mission.Versions.v2025_05_01_preview,
    ManagedResourceGroupConfiguration
  )
  managedResourceGroupName?: string;

  @added(Microsoft.Mission.Versions.v2025_05_01_preview)
  @doc("Managed On Behalf Of Configuration.")
  @visibility(Lifecycle.Read)
  managedOnBehalfOfConfiguration?: CommonTypes.ManagedOnBehalfOfConfiguration;

  @doc("List of services governed by a community.")
  @identifiers(#[])
  governedServiceList?: GovernedServiceItem[];

  #suppress "@azure-tools/typespec-azure-core/no-unnamed-union" "Backwards compatibility - Existing union"
  @added(Microsoft.Mission.Versions.v2025_05_01_preview)
  @doc("Policy override setting for the community. Specifies whether to apply enclave-specific policies or disable policy enforcement.")
  policyOverride?: "Enclave" | "None" | string;

  @added(Microsoft.Mission.Versions.v2024_12_01_preview)
  @doc("Community role assignments")
  @identifiers(#[])
  communityRoleAssignments?: RoleAssignmentItem[];

  @added(Microsoft.Mission.Versions.v2025_05_01_preview)
  @doc("SKU of the community's Azure Firewall (Basic, Standard, Premium). Standard is the default")
  firewallSku?: FirewallSKU = FirewallSKU.Standard;
}

@doc("Community Resource Properties")
model CommunityProperties is CommunityBaseModel {
  @added(Microsoft.Mission.Versions.v2024_12_01_preview)
  @doc("Approval requirements for various actions on the community's resources.")
  approvalSettings?: ApprovalSettings;

  @added(Microsoft.Mission.Versions.v2024_12_01_preview)
  @doc("Maintenance Mode configuration.")
  maintenanceModeConfiguration?: MaintenanceModeConfigurationModel;

  @added(Microsoft.Mission.Versions.v2025_11_01_preview)
  @identifiers(#[])
  @doc("DedicatedHub List.")
  @visibility(Lifecycle.Read)
  dedicatedHubList?: DedicatedHubResource[];

  @added(Microsoft.Mission.Versions.v2026_01_01_preview)
  @doc("Community Monitoring Settings for diagnostic and virtual network flow logs")
  monitoringSettings?: MonitoringSettingsModel;

  @added(Microsoft.Mission.Versions.v2026_03_01_preview)
  @doc("Address spaces list")
  addressSpaces?: string[];
}

@doc("Community Resource Properties without default values")
model CommunityPatchProperties
  is UpdateableProperties<OmitDefaults<CommunityBaseModel>> {
  @added(Microsoft.Mission.Versions.v2024_12_01_preview)
  @doc("Approval requirements for various actions on the community's resources.")
  approvalSettings?: ApprovalSettingsPatchProperties;

  @added(Microsoft.Mission.Versions.v2024_12_01_preview)
  @doc("Maintenance Mode configuration.")
  maintenanceModeConfiguration?: MaintenanceModeConfigurationPatchModel;

  @added(Microsoft.Mission.Versions.v2026_01_01_preview)
  @doc("Community Monitoring Settings for diagnostic and virtual network flow logs")
  monitoringSettings?: MonitoringSettingsPatchModel;

  @added(Microsoft.Mission.Versions.v2026_03_01_preview)
  @doc("Address spaces list")
  addressSpaces?: string[];
}

@doc("Community Patch Resource")
model CommunityPatchModel {
  @doc("Community Patch properties")
  properties?: CommunityPatchProperties;

  ...Azure.ResourceManager.Foundations.ArmTagsProperty;
  ...ManagedServiceIdentityProperty;
}
