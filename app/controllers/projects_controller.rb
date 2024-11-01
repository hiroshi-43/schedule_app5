class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :recalculate]

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
    @tasks = @project.tasks.order(:start_date)
  end

  def edit
    @project = Project.find(params[:id])
  end
  
  def update
    @project = Project.find(params[:id])
    
    if @project.update(project_params)
      redirect_to @project, notice: 'プロジェクトが更新されました。'
    else
      render :edit, alert: '更新に失敗しました。'
    end
  end

  def recalculate
    @project.calculate_schedule  # 再計算ロジックを実行
    if @project.save
      redirect_to edit_project_path(@project), notice: 'スケジュールが再計算されました'
    else
      redirect_to edit_project_path(@project), alert: '再計算中にエラーが発生しました'
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:customer_name, :product_name, :display_volume, :category_id, :shipment_date)
  end

  def project_params
    params.require(:project).permit(
      :customer_name,
      :product_name,
      :display_volume,
      :category_id,
      :shipment_date,
      tasks_attributes: [:id, :name, :start_date, :_destroy] # :id で既存タスクを更新、:_destroy で削除可能に
    )
  end
end
