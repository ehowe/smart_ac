module ApplicationHelper
  def bootstrap_class_for(flash_type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def bootstrap_class_for_alerts(alert)
    { critical: "bg-danger text-white", warning: "bg-warning text-white", notice: "bg-info text-white" }[alert.severity.to_sym]
  end
end
