class RecordtrendController < ApplicationController
  def simpletrend
    @tableRecord=[]
    tableName = params[:tableName]
    #get table schema
    uploadedSchema = Datauploader.getUploadedSchema(tableName)
    if uploadedSchema.size > 0 then
      disabledColumn = get_usertablecolumninfo(tableName)
      uploadedSchema.each do |schema|
        if disabledColumn.size > 0 then
          if !disabledColumn.include?schema[:Field] then
            @tableRecord.append({columnname: schema[:Field], type: schema[:Type], min: 0, max: 0, count: 0, moneyFormat: '', record:[]})
          end
        else
          @tableRecord.append({columnname: schema[:Field], type: schema[:Type], min: 0, max: 0, count: 0, moneyFormat: '', record:[]})
        end
      end

      # find only enable column's reocrds
      my_sql="SELECT #{(@tableRecord.collect{|obj| obj[:columnname]}).join(', ')} FROM #{tableName}"
      resultRecords = ActiveRecord::Base.connection.execute(my_sql)
      if resultRecords.size > 0 then
        resultRecords.each do |result|
          i=0
          result.each do |perFieldValue|
            @tableRecord[i][:record].append(perFieldValue)
            i = i + 1;
          end
        end
      end

      @tableRecord.each do |resultAnalysis|
        recHash = Usertablecolumninformation.where("tablename =? and columnname =?", tableName, resultAnalysis[:columnname]).first
        if recHash then
          resultAnalysis[:moneyFormat]= recHash.moneyformat
        end
        #removing blank, null and nil values from array
        resultAnalysis[:record] = resultAnalysis[:record].reject { |c| c.blank? }
        if ((!(resultAnalysis[:type].include?'varchar')) && (!(resultAnalysis[:type].include?'boolean'))) then
          resultAnalysis[:min] = resultAnalysis[:record].min
          resultAnalysis[:max] = resultAnalysis[:record].max
        end
        resultAnalysis[:count] = resultAnalysis[:record].size
      end
    end
  end
end
