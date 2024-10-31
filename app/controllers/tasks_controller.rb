class TasksController < ApplicationController
  before_action :set_project

  def create
    @task = @project.tasks.build(task_params)
    if @task.save
      redirect_to edit_project_path(@project), notice: 'タスクが追加されました。'
    else
      redirect_to edit_project_path(@project), alert: 'タスクの追加に失敗しました。'
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:name, :start_date)
  end
end
