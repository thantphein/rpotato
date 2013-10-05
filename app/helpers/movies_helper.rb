module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  def helper_class(field)
    if (params[:sort_by].to_s == field)
      return 'hilite'
    end
    return nil
  end

  def helper_sort(movie)
    if (params[:sort_by].to_s == 'title')
      return movie.title
    elsif (params[:sort_by].to_s == 'release_date')
      return movie.release_date.to_s
    end
  end

  def helper_select(movie)
    if (params[:ratings] == nil)
      return true
    else
      return params[:ratings].has_key?(movie.rating)
    end
  end
  
  def helper_check(rating)
    if (params[:ratings] == nil)
      return false
    end
    return params[:ratings].has_key?(rating)
  end
end
