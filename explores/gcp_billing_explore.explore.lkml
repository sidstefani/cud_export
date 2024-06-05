include: "/views/cud_export.view.lkml"
include: "/views/gcp_billing/gcp_billing_export.view"

explore: gcp_billing_export {
  label: "Billing"
  join: gcp_billing_export__labels {
    sql:LEFT JOIN UNNEST(${gcp_billing_export.labels}) as gcp_billing_export__labels ;;
    relationship: one_to_many
  }

  join: gcp_billing_export__system_labels {
    sql:LEFT JOIN UNNEST(${gcp_billing_export.system_labels}) as gcp_billing_export__system_labels ;;
    relationship: one_to_many
  }

  join: gcp_billing_export__project__labels {
    sql:LEFT JOIN UNNEST(${gcp_billing_export.project__labels}) as gcp_billing_export__project__labels ;;
    relationship: one_to_many
  }

  join: gcp_billing_export__credits {
    sql:LEFT JOIN UNNEST(${gcp_billing_export.credits}) as gcp_billing_export__credits ;;
    relationship: one_to_many
  }

  join: cud_export {
    type: left_outer
    sql_on: ${gcp_billing_export.subscription_id} = ${cud_export.subscription_id} ;;
    relationship: many_to_one
  }
}
