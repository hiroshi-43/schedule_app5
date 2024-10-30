class ProjectsController < ApplicationController

  def index
    @projects = Project.all.order(:created_at)
  end
  
  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      @project.calculate_schedule  # スケジュール計算を呼び出す
      redirect_to @project, notice: 'プロジェクトが作成され、スケジュールが計算されました。'
    else
      render :new
    end
  end

  def show
    @project = Project.find(params[:id])
    @tasks = @project.tasks.order(:start_date)
  end

  private

  def project_params
    params.require(:project).permit(:customer_name, :product_name, :display_volume, :category_id, :shipment_date)
  end
end
