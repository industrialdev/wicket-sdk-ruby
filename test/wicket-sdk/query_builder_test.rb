require 'test_helper'

class WicketSDK::QueryBuilderTest < Minitest::Test
  attr_reader :query

  before do
    @query = WicketSDK::QueryBuilder.new(nil, 'path')
  end

  it 'can make a get request to find all resources' do
    assert_equal 'someting', query.all
  end

  it 'can set page details' do
    expected = { page: { number: 2 } }
    assert_equal expected, query.page(2).to_params

    expected = { page: { number: 3, size: 10 } }
    assert_equal expected, query.page(3, 10).to_params
  end

  it 'can include relationships' do
    expected = { include: 'rel1,rel2,rel3' }
    assert_equal expected, query.includes('rel1', :rel2).includes('rel3').to_params
  end

  it 'can handle fields' do
    query
      .fields(res1: :field1)
      .fields(res2: [:field4], res1: :field2)
      .fields(res1: [:field3])

    expected = {
      fields: {
        res1: 'field1,field2,field3',
        res2: 'field4'
      }
    }
    assert_equal expected, query.to_params
  end

  it 'can handle filters' do
    query
      .filter(name_eq: :field1, age_gte: 21)
      .filter(age_lt: 30)

    expected = {
      filter: {
        name_eq: :field1,
        age_gte: 21,
        age_lt: 30
      }
    }

    assert_equal expected, query.to_params
  end

  it 'can handle sorting' do
    query
      .sort(:field1, field2: :desc)
      .sort(field3: :asc)

    expected = {
      sort: 'field1,-field2,field3'
    }

    assert_equal expected, query.to_params
  end
end
