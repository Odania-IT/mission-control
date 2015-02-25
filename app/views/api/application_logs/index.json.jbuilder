json.page @application_logs.current_page
json.per_page Kaminari.config.default_per_page
json.total_row_count @application_logs.total_count
json.total_page_count @application_logs.total_pages

json.application_logs @application_logs, partial: 'api/application_logs/show', as: :application_log
