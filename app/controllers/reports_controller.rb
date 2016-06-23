class ReportsController < ApplicationController
  
  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all

  end

  def download
    report = Report.find(params[:report_id])
    report_details = report.report_details

    respond_to do |format|
      format.html
      format.csv { send_data report_details.to_csv, filename: "report-#{params[:report_id]}-details-#{report.created_at}.csv" }
    end
  end


  def create
    #processes = Report.get_processes(sort_column, sort_direction, filter_column, filter_text)

    processes = Report.get_processes(filter_column, filter_text)
    
    if processes.length > 0

      report = Report.new(
        report_date: Time.now, 
        report_user: session[:user_name], 
        description: params[:description],
        filter_column: filter_column,
        filter_text: filter_text
        )

      report.report_details.build(processes)

      respond_to do |format|
        if report.save
          format.html { redirect_to reports_index_path, notice: 
            "New report generated on #{report.report_date}"}
        else format.html { redirect_to reports_index_path, alert: 
            "Failed to generate report"}
        end
      end

    else
      redirect_to reports_index_path, alert: "No processes matching filter options. No report generated."
    end
    
  end

  def destroy
    rep = Report.find(params[:report_id])

    respond_to do |format|
      if rep.destroy
        format.html { redirect_to reports_index_path, notice: 
          "Report #{params[:report_id]} has been deleted."}
      else format.html { redirect_to reports_index_path, notice: 
          "Report #{params[:report_id]} could not be deleted."}
      end
    end
    
  end

  def show
  end

  def filter_column
    params[:filter_column]
  end

  def filter_text
    if params[:filter] && params[:filter].chomp == ""
      return nil
    end

    return params[:filter]
  end


end
