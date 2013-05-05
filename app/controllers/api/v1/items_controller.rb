module Api
  module V1
    class ItemsController < ApplicationController
      
      respond_to :json

      def index
        begin 
          category_id = params[:categoryId]
          barcode = params[:barcode]
            
          if (category_id)
            @items = Item.includes(:categories).where(:categories => { :id => category_id })
            @categories = Category.where("parent_id = ?", category_id)
            process_items_list_json(@items, @categories)
          elsif (barcode)
            @item = Item.where("barcode = ?", params[:barcode]).first
            
            if @item
              process_item_json(@item)
            else 
              raise ActiveRecord::RecordNotFound
            end
          else
            @items = []
            @categories = Category.where("parent_id IS NULL")
            process_items_list_json(@items, @categories)
          end              
          
        rescue ActiveRecord::RecordNotFound

          respond_with( {
            :statusCode => 1,
            :statusMessage => "Failed to process request"
          })

        end
      end

      def show
        begin
          @item = Item.find(params[:id])

          render :json => { 
            :statusCode => 0, 
            :statusMessage => 'Sucess',          
            :item => @item.as_json(
              :include => { :property_valuations => { :except  => [:id, :item_id, :property_id, :profile_id, :created_at, :updated_at], 
              :include => { :property => { :include => [:unit], :except => [:unit_id, :created_at, :updated_at] } }
              }})
          }
        rescue ActiveRecord::RecordNotFound
          respond_with( {
            :statusCode => 1,
            :statusMessage => "Failed to get item"
          })
        end
      end

      def navigate        
        begin 
          category_id = params[:category_id]
                      
          if (category_id)
            puts "Filtering based on category id"
            @items = Item.includes(:categories).where(:categories => { :id => category_id })
            @categories = Category.where("parent_id = ?", category_id)            
          else
            @items = []
            @categories = Category.where("parent_id IS NULL")            
          end 

          if params[:rules]
            puts "Processing rules"
            @items = process_rules_filter(@items)
          else
            puts "No rules to process"
          end

          process_items_list_json(@items, @categories)
          
        rescue ActiveRecord::RecordNotFound
          
          respond_with( {
            :statusCode => 1,
            :statusMessage => "Failed to process request"
          })

        end
      end

      def search
        # parse parameters: keywords, categories, properties
        # params[:keywords]
        # params[:rules] = [{ "property_id": 1, "min_value": 1, "max_value": 2, "exact_value": null}]
        # params[:category_id]

        @items_list = []
        
        if (!params[:category_id] or params[:category_id] == -1)
          if (params[:keywords].to_s == '')
            @items_list = Item.all
          else            
            @items_list = Item.where("lower(items.name) like ?", "%#{params[:keywords].downcase}%")
          end          
        else

          @category = Category.find(params[:category_id])

          if (params[:keywords].to_s == '')
            @items_list = @category.items
          else                 
            @items_list = @category.items.where("lower(items.name) like ?", "%#{params[:keywords].downcase}%")
          end

          unless @category.blank?            
            @children_list = [@category]
            @items_list = @category.all_items(@children_list, @items_list, params[:keywords])
          end
        end

        if params[:rules]
          puts "Processing rules"
          @items_list = process_rules_filter(@items_list)
        else
          puts "No rules to process"
        end

        render :json => {
          :statusCode => 0, 
          :statusMessage => 'Sucess', 
          :items => @items_list
        }
      end

      def process_rules_filter(items_list)
        result = []

        items_list.each do |item|
          
          add_item = false

          params[:rules].each do |rule|            

            unless rule[:property_id].to_s == ''
              
              property_valuation = item.property_valuations.detect { |pv| pv.property.id == rule[:property_id] }
              
              if property_valuation and property_valuation.value.to_s != ''
                
                if rule[:exact_value].to_s != '' and rule[:exact_value].to_s != -1
                  if property_valuation.value.to_i == rule[:exact_value].to_i
                    add_item = true
                  else
                    add_item = false;
                    break;
                  end
                else

                  if rule[:min_value].to_s != '' and rule[:min_value].to_s != -1
                    if property_valuation.value.to_i >= rule[:min_value].to_i
                      add_item = true  
                    else
                      add_item = false
                      break;
                    end
                  end

                  if rule[:max_value].to_s != '' and rule[:max_value].to_s != -1
                    if property_valuation.value.to_i <= rule[:max_value].to_i
                      add_item = true
                    else
                      add_item = false
                      break;
                    end
                  end

                end

              end

            end            
          end

          result.push(item) if add_item == true

        end

        result
      end

      def process_item_json(items)
        render :json => { 
            :statusCode => 0, 
            :statusMessage => 'Sucess',          
            :item => items.as_json(
              :include => { :property_valuations => { :except  => [:id, :item_id, :property_id, :profile_id, :created_at, :updated_at], 
              :include => { :property => { :include => [:unit], :except => [:unit_id, :created_at, :updated_at] } }
              }})
          }
      end

      def process_items_list_json(items, categories)
        render :json => {
            :statusCode => 0, 
            :statusMessage => 'Sucess', 
            :categories => categories,
            :items => items.as_json(
              :include => { :property_valuations => { :except  => [:id, :item_id, :property_id, :profile_id, :created_at, :updated_at], 
              :include => { :property => { :include => [:unit], :except => [:unit_id, :created_at, :updated_at] } }
              }})          
          }
      end

    end
  end
end
