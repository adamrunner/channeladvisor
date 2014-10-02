module ChannelAdvisor
  module Services
    class InventoryService < BaseService
      document "https://api.channeladvisor.com/ChannelAdvisorAPI/v6/InventoryService.asmx?WSDL"

      class << self
        def ping
          client.request :ping do
            soap.header = soap_header
          end
        end # ping

        def update_inventory_item_quantity_and_price(item_info)
          soap_body = {
            "ins0:accountID" => creds(:account_id),
            "ins0:itemQuantityAndPrice" => {
              "ins0:Sku" => item_info[:sku]
            }
          }

          item_quantity_and_price = soap_body["ins0:itemQuantityAndPrice"]

          if quantity_info = item_info[:quantity_info]
            item_quantity_and_price["ins0:QuantityInfo"] = {
              "ins0:UpdateType" => quantity_info[:update_type],
              "ins0:Total"      => quantity_info[:total]
            }
          end

          if price_info = item_info[:price_info]
            item_quantity_and_price["ins0:PriceInfo"] = {
              "ins0:Cost"                   => price_info[:cost],
              "ins0:RetailPrice"            => price_info[:retail_price],
              "ins0:StartingPrice"          => price_info[:starting_price],
              "ins0:ReservePrice"           => price_info[:reserve_price],
              "ins0:TakeItPrice"            => price_info[:take_it_price],
              "ins0:SecondChanceOfferPrice" => price_info[:second_chance_offer_price],
              "ins0:StorePrice"             => price_info[:store_price]
            }
          end

          client.request :update_inventory_item_quantity_and_price do
            soap.header = soap_header
            soap.body = soap_body
          end
        end # update_inventory_item_quantity_and_price

        def update_inventory_item_quantity_and_price_list(quantity_and_price_list)
          soap_body = {
            "ins0:accountID" => creds(:account_id),
            "ins0:itemQuantityAndPriceList" => {
              "ins0:InventoryItemQuantityAndPrice" => []
            }
          }

          quantity_and_price_list.each do |item|
            item_quantity_and_price = {"ins0:Sku" => item[:sku]}

            if quantity_info = item[:quantity_info]
              item_quantity_and_price["ins0:QuantityInfo"] = {
                "ins0:UpdateType" => item[:quantity_info][:update_type],
                "ins0:Total"      => item[:quantity_info][:total]
              }
            end

            if price_info = item[:price_info]
              item_quantity_and_price["ins0:PriceInfo"] = {
                "ins0:Cost"                   => price_info[:cost],
                "ins0:RetailPrice"            => price_info[:retail_price],
                "ins0:StartingPrice"          => price_info[:starting_price],
                "ins0:ReservePrice"           => price_info[:reserve_price],
                "ins0:TakeItPrice"            => price_info[:take_it_price],
                "ins0:SecondChanceOfferPrice" => price_info[:second_chance_offer_price],
                "ins0:StorePrice"             => price_info[:store_price]
              }
            end

            soap_body["ins0:itemQuantityAndPriceList"]["ins0:InventoryItemQuantityAndPrice"] << item_quantity_and_price
          end


          client.request :update_inventory_item_quantity_and_price_list do
            soap.header = soap_header
            soap.body = soap_body
          end
        end # update_inventory_item_quantity_and_price_list

        def sync_inventory_item(item)
          soap_body = {
            "ins0:accountID" => creds(:account_id),
            "ins0:item"  => item_info =  {
              "ins0:Sku"                 => item[:sku],
              "ins0:Title"               => item[:title],
              "ins0:Subtitle"            => item[:subtitle],
              "ins0:ShortDescription"    => item[:short_description],
              "ins0:Description"         => item[:description],
              "ins0:Weight"              => item[:weight],
              "ins0:SupplierCode"        => item[:supplier_code],
              "ins0:WarehouseLocation"   => item[:warehouse_location],
              "ins0:TaxProductCode"      => item[:tax_product_code],
              "ins0:FlagStyle"           => item[:flag_style],
              "ins0:FlagDescription"     => item[:flag_description],
              "ins0:IsBlocked"           => item[:is_blocked],
              "ins0:BlockComment"        => item[:block_comment],
              "ins0:ASIN"                => item[:asin],
              "ins0:ISBN"                => item[:isbn],
              "ins0:UPC"                 => item[:upc],
              "ins0:MPN"                 => item[:mpn],
              "ins0:EAN"                 => item[:ean],
              "ins0:Manufacturer"        => item[:manufacturer],
              "ins0:Brand"               => item[:brand],
              "ins0:Condition"           => item[:condition],
              "ins0:Warranty"            => item[:warranty],
              "ins0:ProductMargin"       => item[:product_margin],
              "ins0:SupplierPO"          => item[:supplier_po],
              "ins0:ReceivedInInventory" => item[:received_in_inventory],
              "ins0:HarmonizedCode"      => item[:harmonized_code],
              "ins0:Height"              => item[:height],
              "ins0:Length"              => item[:length],
              "ins0:Width"               => item[:width],
              "ins0:Classification"      => item[:classification],
              "ins0:AttributeList"       => item[:attribute_list],
              "ins0:ImageList"           => item[:image_list],
              "ins0:LabelList"           => item[:label_list],
              "ins0:Label"               => item[:label],
              "ins0:MetaDescription"     => item[:meta_description],
              "ins0:PriceInfo"           => item[:price_info],
              "ins0:QuantityInfo"        => item[:quantity_info],
              "ins0:VariationInfo"       => item[:variation_info],
              "ins0:ShippingInfo"        => item[:shipping_info],
              "ins0:StoreInfo"           => item[:store_info]
            }
          }
            if quantity_info = item[:quantity_info]
              item_info["ins0:QuantityInfo"] = {
                "ins0:UpdateType" => item[:quantity_info][:update_type],
                "ins0:Total"      => item[:quantity_info][:total]
              }
            end

            if price_info = item[:price_info]
              item_info["ins0:PriceInfo"] = {
                "ins0:Cost"                   => price_info[:cost],
                "ins0:RetailPrice"            => price_info[:retail_price],
                "ins0:StartingPrice"          => price_info[:starting_price],
                "ins0:ReservePrice"           => price_info[:reserve_price],
                "ins0:TakeItPrice"            => price_info[:take_it_price],
                "ins0:SecondChanceOfferPrice" => price_info[:second_chance_offer_price],
                "ins0:StorePrice"             => price_info[:store_price]
              }
            end
            if variation_info = item[:variation_info]
              item_info["ins0:VariationInfo"] = {
                "ins0:IsInRelationship" => variation_info[:is_in_relationship],
                "ins0:RelationshipName" => variation_info[:relationship_name],
                "ins0:IsParent"         => variation_info[:is_parent],
                "ins0:ParentSku"        => variation_info[:parent_sku]
              }
            end
            if store_info = item[:store_info]
              item_info["ins0:StoreInfo"] = {
                "ins0:DisplayInStore" => store_info[:display_in_store],
                "ins0:Title"          => store_info[:title],
                "ins0:Description"    => store_info[:description],
                "ins0:CategoryID"     => store_info[:category_id]   
              }
            end

          client.request :update_inventory_item_quantity_and_price do
            soap.header = soap_header
            soap.body = soap_body
          end          
        end

        def sync_inventory_item_list(item_list)
          soap_body = {
            "ins0:accountID" => creds(:account_id),
            "ins0:SynchInventoryItemList" => {
              "ins0:itemList"  => []
            }
          }
          item_list.each do |item|
            item_info = {
              "ins0:Sku"                 => item[:sku],
              "ins0:Title"               => item[:title],
              "ins0:Subtitle"            => item[:subtitle],
              "ins0:ShortDescription"    => item[:short_description],
              "ins0:Description"         => item[:description],
              "ins0:Weight"              => item[:weight],
              "ins0:SupplierCode"        => item[:supplier_code],
              "ins0:WarehouseLocation"   => item[:warehouse_location],
              "ins0:TaxProductCode"      => item[:tax_product_code],
              "ins0:FlagStyle"           => item[:flag_style],
              "ins0:FlagDescription"     => item[:flag_description],
              "ins0:IsBlocked"           => item[:is_blocked],
              "ins0:BlockComment"        => item[:block_comment],
              "ins0:ASIN"                => item[:asin],
              "ins0:ISBN"                => item[:isbn],
              "ins0:UPC"                 => item[:upc],
              "ins0:MPN"                 => item[:mpn],
              "ins0:EAN"                 => item[:ean],
              "ins0:Manufacturer"        => item[:manufacturer],
              "ins0:Brand"               => item[:brand],
              "ins0:Condition"           => item[:condition],
              "ins0:Warranty"            => item[:warranty],
              "ins0:ProductMargin"       => item[:product_margin],
              "ins0:SupplierPO"          => item[:supplier_po],
              "ins0:ReceivedInInventory" => item[:received_in_inventory],
              "ins0:HarmonizedCode"      => item[:harmonized_code],
              "ins0:Height"              => item[:height],
              "ins0:Length"              => item[:length],
              "ins0:Width"               => item[:width],
              "ins0:Classification"      => item[:classification],
              "ins0:AttributeList"       => item[:attribute_list],
              "ins0:ImageList"           => item[:image_list],
              "ins0:LabelList"           => item[:label_list],
              "ins0:Label"               => item[:label],
              "ins0:MetaDescription"     => item[:meta_description],
              "ins0:PriceInfo"           => item[:price_info],
              "ins0:QuantityInfo"        => item[:quantity_info],
              "ins0:VariationInfo"       => item[:variation_info],
              "ins0:ShippingInfo"        => item[:shipping_info],
              "ins0:StoreInfo"           => item[:store_info]
            }
        
            if quantity_info = item[:quantity_info]
              item_info["ins0:QuantityInfo"] = {
                "ins0:UpdateType" => item[:quantity_info][:update_type],
                "ins0:Total"      => item[:quantity_info][:total]
              }
            end

            if price_info = item[:price_info]
              item_info["ins0:PriceInfo"] = {
                "ins0:Cost"                   => price_info[:cost],
                "ins0:RetailPrice"            => price_info[:retail_price],
                "ins0:StartingPrice"          => price_info[:starting_price],
                "ins0:ReservePrice"           => price_info[:reserve_price],
                "ins0:TakeItPrice"            => price_info[:take_it_price],
                "ins0:SecondChanceOfferPrice" => price_info[:second_chance_offer_price],
                "ins0:StorePrice"             => price_info[:store_price]
              }
            end
            if variation_info = item[:variation_info]
              item_info["ins0:VariationInfo"] = {
                "ins0:IsInRelationship" => variation_info[:is_in_relationship],
                "ins0:RelationshipName" => variation_info[:relationship_name],
                "ins0:IsParent"         => variation_info[:is_parent],
                "ins0:ParentSku"        => variation_info[:parent_sku]
              }
            end
            if store_info = item[:store_info]
              item_info["ins0:StoreInfo"] = {
                "ins0:DisplayInStore" => store_info[:display_in_store],
                "ins0:Title"          => store_info[:title],
                "ins0:Description"    => store_info[:description],
                "ins0:CategoryID"     => store_info[:category_id]       
              }
            end
            soap_body["ins0:SynchInventoryItemList"]["ins0:itemList"] << item_info
          end
          client.request :synch_inventory_item_list do
            soap.header = soap_header
            soap.body = soap_body
          end          
        end #sync_inventory_item_list
      end # self
    end # InventoryService
  end # Services
end # ChannelAdvisor