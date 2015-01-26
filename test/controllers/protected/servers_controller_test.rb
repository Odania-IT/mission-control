require 'test_helper'

class Protected::ServersControllerTest < ActionController::TestCase
  setup do
    @protected_server = protected_servers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:protected_servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create protected_server" do
    assert_difference('Protected::Server.count') do
      post :create, protected_server: { active: @protected_server.active, cpu: @protected_server.cpu, hostname: @protected_server.hostname, ip: @protected_server.ip, memory: @protected_server.memory, name: @protected_server.name }
    end

    assert_redirected_to protected_server_path(assigns(:protected_server))
  end

  test "should show protected_server" do
    get :show, id: @protected_server
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @protected_server
    assert_response :success
  end

  test "should update protected_server" do
    patch :update, id: @protected_server, protected_server: { active: @protected_server.active, cpu: @protected_server.cpu, hostname: @protected_server.hostname, ip: @protected_server.ip, memory: @protected_server.memory, name: @protected_server.name }
    assert_redirected_to protected_server_path(assigns(:protected_server))
  end

  test "should destroy protected_server" do
    assert_difference('Protected::Server.count', -1) do
      delete :destroy, id: @protected_server
    end

    assert_redirected_to protected_servers_path
  end
end
