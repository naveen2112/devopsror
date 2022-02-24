class TrailCalculationAndUpdateJob < ApplicationJob
  queue_as :default

  def perform
    Company.product_led_plan.each do |company|
      company.update(trail_end_date: Date.current, next_billing_date: (Date.current + 30.days))  if company.trail_start_date == (Date.current - 14.days)
    end
  end
end
