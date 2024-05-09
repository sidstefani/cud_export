view: cud_export {
  view_label: "CUD Export"
  sql_table_name: `@{CUDEXPORT}` ;;

  dimension: active_commitment {
    type: number
    hidden: yes
    description: "A field used to calculate the total active commitment."
    sql: ${TABLE}.Active_Commitment ;;
  }

  dimension: auto_renew {
    type: string
    description: "Indicates whether the commitment will automatically renew at the end of its term."
    sql: ${TABLE}.Auto_Renew ;;
  }

  dimension: commitment_fee_sku {
    type: string
    hidden: yes
    description: "A field used to identify the service and sku assocaited with the commitment."
    sql: ${TABLE}.Commitment_Fee_Sku ;;
  }

  dimension: commitment_service {
    type: string
    description: "An identifier for the billing SKU of the commitment fee."
    sql: SPLIT(SPLIT(${commitment_fee_sku}, '/')[OFFSET(1)], '/skus/')[OFFSET(0)];;
  }

  dimension: commitment_sku {
    type: string
    label: "Commitment SKU"
    description: "An identifier for the billing Service of the commitment fee."
    sql: SPLIT(SPLIT(${commitment_fee_sku}, '/skus/')[OFFSET(1)], '/')[OFFSET(0)];;
  }

  dimension_group: end {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    description: "The date and time the commitment period ends."
    convert_tz: no
    datatype: date
    sql: ${TABLE}.End_Time ;;
  }

  dimension: machine_family {
    type: string
    description: "The family of machine types included in the commitment."
    sql: ${TABLE}.Machine_Family ;;
  }

  dimension: price {
    type: number
    hidden: yes
    description: "A field used to calculate the total price."
    sql: ${TABLE}.Price ;;
  }

  dimension: prioritized_attribution {
    type: string
    description: "Determines how the CUD discount is applied when multiple discounts are available."
    sql: ${TABLE}.Prioritized_Attribution ;;
  }

  dimension: region {
    type: string
    description: "The geographic location where the commitment applies."
    sql: ${TABLE}.Region ;;
  }

  dimension: resource_type {
    type: string
    description: "The specific type of resource covered by the commitment."
    sql: ${TABLE}.Resource_Type ;;
  }

  dimension_group: start {
    type: time
    description: "The date and time the commitment period begins."
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Start_Time ;;
  }

  dimension_group: commitment_duration {
    type: duration
    intervals:  [day]
    description: "The total length of the commitment period expressed in days."
    sql_start: ${start_date} ;;
    sql_end: ${end_date};;
  }

  dimension: state {
    type: string
    description: "The current status of the commitment, whether active or expired."
    sql: ${TABLE}.State ;;
  }

  dimension: subscription_container {
    type: string
    description: "The Google Cloud project or folder associated with the commitment."
    sql: ${TABLE}.Subscription_Container ;;
  }

  dimension: subscription {
    type: string
    hidden:  yes
    description: "A field used to identify the subscription ID."
    sql: ${TABLE}.Subscription_Id ;;
  }

  dimension: subscription_id {
    type: string
    description: "A unique identifier for the commitment."
    sql: SPLIT(${subscription}, '/')[OFFSET(1)] ;;
  }

  dimension: subscription_name {
    type: string
    label: "A descriptive name for the commitment."
    sql: ${TABLE}.Subscription_Name ;;
  }

  dimension: term {
    type: string
    description: "The length of the commitment period, typically specified in years (e.g., 1 year or 3 years), during which the discounted pricing applies."
    sql: ${TABLE}.Term ;;
  }

  dimension: type {
    type: string
    description: "Specifies whether the commitment is resource-based, spend-based, or a flexible commitment."
    sql: ${TABLE}.Type ;;
  }

  dimension: cud_type_group {
    type: string
    label: "CUD Type Group"
    sql: case when ${type} like '%Flexible%' then "Flex CUD"
          when ${type} like '%Resource%' then "Resourced Based CUD"
          else "Spend Based CUD" end;;
    description: "Categorizes the CUD into one of the following types: Flex CUD, Resource Based CUD, and Spend Based CUD."
  }

  dimension: unit {
    type: string
    description: "The measurement used for the committed resource or spend."
    sql: ${TABLE}.Unit ;;
  }

  ############ MEASURES ############

  measure: total_active_commitment {
    type: sum
    description: "The amount of resources or spending committed to."
    value_format_name: decimal_2
    sql: ${active_commitment} ;;
  }

  measure: total_price {
    type: sum
    description: "The discounted price per unit of usage under the commitment."
    value_format_name: usd_0
    sql: ${price} ;;
  }

  measure: count {
    type: count
    description: "Total count of CUD subscriptions."
    drill_fields: [subscription_name]
  }
}
