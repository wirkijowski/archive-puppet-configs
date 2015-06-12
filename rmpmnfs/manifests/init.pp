# = Class: rmpmnfs
#
# This class removes unwanted services from default debian installation.
#

class rmpmnfs {
    include rmpmnfs::stop, rmpmnfs::remove
}
