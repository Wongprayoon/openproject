#-- encoding: UTF-8

#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2019 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

module Versions
  class UpdateService
    include Concerns::Contracted

    attr_reader :user,
                :version

    def initialize(user:, version:)
      @user = user
      @version = version
      self.contract_class = Versions::UpdateContract
    end

    def call(params)
      attributes_call = set_attributes(params)

      if attributes_call.success? &&
         !attributes_call.result.save
        attributes_call.errors = attributes_call.result.errors
        attributes_call.success = false
      end

      attributes_call
    end

    private

    def set_attributes(params)
      SetAttributesService
        .new(user: user,
             version: version,
             contract_class: contract_class)
        .call(params)
    end
  end
end
