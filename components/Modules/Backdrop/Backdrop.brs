sub init()
    m.released = m.top.findNode("released")
end sub

sub formatReleaseDate()
    dateString = m.top.releaseDate
    if invalid <> dateString and "" <> dateString
        dateString = dateString.split("-")
        m.released.text = "(" + dateString[0] + ")"
    end if
end sub