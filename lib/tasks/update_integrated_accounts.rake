task :update_integrated_accounts => :environment do |_t, args|

  IntegratedAccount.all.each do |integrated_account|
    integrated_account.update(company_id: integrated_account.user.company.id)
  end
end