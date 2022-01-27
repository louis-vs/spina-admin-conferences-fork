# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class InstitutionsControllerTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
        include ::Spina::Engine.routes.url_helpers

        setup do
          @institution = spina_admin_conferences_institutions :university_of_atlantis
          @invalid_institution = Institution.new
          @empty_institution = spina_admin_conferences_institutions :empty_institution
          @user = spina_users :joe
          post admin_sessions_url, params: { email: @user.email, password: 'password' }
        end

        test 'should get index' do
          get admin_conferences_institutions_url
          assert_response :success
        end

        test 'should get new' do
          get new_admin_conferences_institution_url
          assert_response :success
          assert_select '#delegates tbody > tr' do
            assert_select 'td', 'There are no delegates'
          end
          assert_select '#rooms tbody > tr' do
            assert_select 'td', 'There are no rooms'
          end
        end

        test 'should get edit' do
          get edit_admin_conferences_institution_url(@institution)
          assert_response :success
          assert_select('#delegates tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
          assert_select('#rooms tbody > tr') do |table_rows|
            table_rows.each { |row| assert_select row, 'td', 4 }
          end
        end

        test 'should create institution' do
          attributes = @institution.attributes
          attributes[:name] = @institution.name
          attributes[:city] = @institution.city
          assert_difference 'Institution.count' do
            post admin_conferences_institutions_url, params: { institution: attributes }
          end
          assert_redirected_to admin_conferences_institutions_url
          assert_equal 'Institution saved', flash[:success]
        end

        test 'should create institution with remote form' do
          attributes = @institution.attributes
          attributes[:name] = @institution.name
          attributes[:city] = @institution.city
          assert_difference 'Institution.count' do
            post admin_conferences_institutions_url, params: { institution: attributes }, as: :turbo_stream
          end
          assert_redirected_to admin_conferences_institutions_url
          assert_equal 'Institution saved', flash[:success]
        end

        test 'should fail to create invalid institution' do
          attributes = @invalid_institution.attributes
          attributes[:name] = @invalid_institution.name
          attributes[:city] = @invalid_institution.city
          assert_no_difference 'Institution.count' do
            post admin_conferences_institutions_url, params: { institution: attributes }
          end
          assert_response :unprocessable_entity
          assert_not_equal 'Institution saved', flash[:success]
        end

        test 'should fail to create invalid institution with remote form' do
          attributes = @invalid_institution.attributes
          attributes[:name] = @invalid_institution.name
          attributes[:city] = @invalid_institution.city
          assert_no_difference 'Institution.count' do
            post admin_conferences_institutions_url, params: { institution: attributes }, as: :turbo_stream
          end
          assert_response :unprocessable_entity
          assert_not_equal 'Institution saved', flash[:success]
        end

        test 'should update institution' do
          attributes = @institution.attributes
          attributes[:name] = @institution.name
          attributes[:city] = @institution.city
          patch admin_conferences_institution_url(@institution), params: { institution: attributes }
          assert_redirected_to admin_conferences_institutions_url
          assert_equal 'Institution saved', flash[:success]
        end

        test 'should update institution with remote form' do
          attributes = @institution.attributes
          attributes[:name] = @institution.name
          attributes[:city] = @institution.city
          patch admin_conferences_institution_url(@institution), params: { institution: attributes }, as: :turbo_stream
          assert_redirected_to admin_conferences_institutions_url
          assert_equal 'Institution saved', flash[:success]
        end

        test 'should fail to update invalid institution' do
          attributes = @invalid_institution.attributes
          attributes[:name] = @invalid_institution.name
          attributes[:city] = @invalid_institution.city
          patch admin_conferences_institution_url(@institution), params: { institution: attributes }
          assert_response :unprocessable_entity
          assert_not_equal 'Institution saved', flash[:success]
        end

        test 'should fail to update invalid institution with remote form' do
          attributes = @invalid_institution.attributes
          attributes[:name] = @invalid_institution.name
          attributes[:city] = @invalid_institution.city
          patch admin_conferences_institution_url(@institution), params: { institution: attributes }, as: :turbo_stream
          assert_response :unprocessable_entity
          assert_not_equal 'Institution saved', flash[:success]
        end

        test 'should destroy institution' do
          assert_difference 'Institution.count', -1 do
            delete admin_conferences_institution_url(@empty_institution)
          end
          assert_redirected_to admin_conferences_institutions_url
          assert_equal 'Institution deleted', flash[:success]
        end

        test 'should destroy institution with remote form' do
          assert_difference 'Institution.count', -1 do
            delete admin_conferences_institution_url(@empty_institution), as: :turbo_stream
          end
          assert_redirected_to admin_conferences_institutions_url
          assert_equal 'Institution deleted', flash[:success]
        end

        test 'should fail to destroy institution with dependent records' do
          assert_no_difference 'Institution.count' do
            delete admin_conferences_institution_url(@institution)
          end
          assert_response :unprocessable_entity
          assert_not_equal 'Institution deleted', flash[:success]
        end

        test 'should fail to destroy institution with dependent records with remote form' do
          assert_no_difference 'Institution.count' do
            delete admin_conferences_institution_url(@institution), as: :turbo_stream
          end
          assert_response :unprocessable_entity
          assert_not_equal 'Institution deleted', flash[:success]
        end
      end
    end
  end
end
