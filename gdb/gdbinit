set print pretty on
set print object on
set print static-members on
set print demangle on
set print sevenbit-strings off
set auto-load safe-path $debugdir:$datadir/auto-load:/

python
import sys
sys.path.insert(0, '/data/thirdparty/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
