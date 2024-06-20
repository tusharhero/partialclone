#!/bin/sh
# partialclone.sh - Clone a single directory or file from a Git repository.
# Copyright (C) 2024 tusharhero

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

giturl=$1
content=$2

cachedir="${XDG_CACHE_HOME:-$HOME/.cache}/partialclone"
cachedir="${PARTIALCLONE_CACHE:-$cachedir}"

namespace=$(echo "$giturl" | awk -F '/' '{ print $(NF-1) }')
repository=$(echo "$giturl" | awk -F '/' '{ print $(NF) }')
cacherepo="$cachedir/$namespace/$repository"
mkdir "$cacherepo" -p


if [ -d "$cacherepo/.git" ]
then
    git pull "$cacherepo"
else
    git clone "$giturl" "$cacherepo" --depth 1
fi

cp "$cacherepo/$content" . -r
