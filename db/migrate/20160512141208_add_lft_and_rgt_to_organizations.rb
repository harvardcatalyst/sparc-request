class AddLftAndRgtToOrganizations < ActiveRecord::Migration
  def up
    add_column :organizations, :lft, :integer
    add_column :organizations, :rgt, :integer
    Organization.reset_column_information

    # convert from adjancency table to modified pre-order
    left = 1
    Organization.where(parent_id: nil).each do |parent|
      left = AddLftAndRgtToOrganizations.migrateChildren(parent, left)
    end
  end

  def down
    remove_column :organizations, :lft
    remove_column :organizations, :rgt
  end

  def self.migrateChildren(parent, left)
    right = left + 1

    Organization.where(parent_id: parent.id).order(:order).each do |child|
      right = AddLftAndRgtToOrganizations.migrateChildren(child, right)
    end

    parent.update_attribute(:lft, left)
    parent.update_attribute(:rgt, right)

    right + 1
  end

  # def self.displayTree(parent)
  #   right = []
  #   descendants = Organization.where("lft BETWEEN ? AND ?", parent.lft, parent.rgt).order(:lft)
  #   descendants.each do |child|
  #     if right.present?
  #       while right[-1] < child.rgt
  #         right = right[0...-1]
  #       end
  #     end
  #
  #     puts "  " * right.length + "(#{child.id})#{child.name} (#{child.parent_id})"
  #     right << child.rgt
  #   end
  # end
end
